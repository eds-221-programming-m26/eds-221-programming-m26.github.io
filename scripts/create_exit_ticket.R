# ---------------------------------------------------------------------------
# create_exit_ticket.R
#
# Creates a new Google Form exit ticket by duplicating an existing one (e.g.
# the day 6 AM/PM exit tickets), placing the copy in the same Drive folder
# as the source.
#
# ONE-TIME SETUP (console.cloud.google.com):
#   1. Create (or select) a project.
#   2. APIs & Services > Library > enable "Google Forms API" and
#      "Google Drive API".
#   3. APIs & Services > OAuth consent screen > configure it (External is
#      fine; add your own Google account under "Test users").
#   4. APIs & Services > Credentials > Create Credentials > OAuth client ID
#      > Application type: "Desktop app". Download the JSON.
#   5. Save the downloaded file as client_secret.json in the project root
#      (already covered by .gitignore -- never commit this file).
#
# Note on scopes: duplicating a form you didn't create with *this* app
# requires the broad "drive" scope (drive.file only sees files the app
# itself created/opened), so the consent screen will show a sensitive-scope
# warning -- expected, since this is an admin script you run yourself.
#
# The first time you call duplicate_exit_ticket() or find_forms(), a browser
# window opens for you to sign in and grant access. gargle caches the token
# in .secrets/ (also gitignored) so later runs won't need to re-authenticate.
# ---------------------------------------------------------------------------

library(gargle)
library(httr)

options(gargle_oauth_cache = ".secrets")

SCOPES <- c(
  "https://www.googleapis.com/auth/forms.body",
  "https://www.googleapis.com/auth/drive"
)

forms_client <- function() {
  gargle::gargle_oauth_client_from_json(
    path = "client_secret.json",
    name = "eds221-exit-tickets"
  )
}

drive_token <- function() {
  gargle::credentials_user_oauth2(scopes = SCOPES, client = forms_client())
}

api_request <- function(url, method = "GET", body = NULL, query = NULL, token) {
  resp <- httr::VERB(
    method,
    url,
    httr::config(token = token),
    query = query,
    body = body,
    encode = "json"
  )
  httr::stop_for_status(resp, task = paste(method, url))
  httr::content(resp, as = "parsed")
}

#' Search Drive for candidate forms by (partial) name
#'
#' Use this to find the file ID of an existing exit ticket -- the forms.gle
#' link and the .../viewform link both use a *different* published id, not
#' the Drive file id these functions need. Look for the id in the returned
#' webViewLink instead (.../forms/d/{id}/edit).
find_forms <- function(name_query, token = drive_token()) {
  res <- api_request(
    "https://www.googleapis.com/drive/v3/files",
    query = list(
      q = sprintf(
        "mimeType = 'application/vnd.google-apps.form' and name contains '%s' and trashed = false",
        name_query
      ),
      fields = "files(id, name, parents, webViewLink)"
    ),
    token = token
  )
  res$files
}

#' Publish a form and turn on accepting responses
#'
#' A form copied via Drive's files.copy is created as an unpublished draft
#' (Google Forms tracks "published" separately from "accepting responses"),
#' so its viewform link shows "We're sorry. This document is not published."
#' until this is called.
publish_form <- function(form_id, token = drive_token()) {
  api_request(
    paste0(
      "https://forms.googleapis.com/v1/forms/",
      form_id,
      ":setPublishSettings"
    ),
    method = "POST",
    body = list(
      publishSettings = list(
        publishState = list(
          isPublished = TRUE,
          isAcceptingResponses = TRUE
        )
      )
    ),
    token = token
  )
}

#' Duplicate an existing Google Form into the same Drive folder(s)
#'
#' @param source_form_id File id of the form to copy (the {id} in
#'   docs.google.com/forms/d/{id}/edit). Use find_forms() to look it up.
#' @param new_title Title for the duplicated form.
#' @return list(form_id, edit_url, responder_url)
duplicate_exit_ticket <- function(
  source_form_id,
  new_title,
  token = drive_token()
) {
  source_meta <- api_request(
    paste0("https://www.googleapis.com/drive/v3/files/", source_form_id),
    query = list(fields = "parents"),
    token = token
  )

  copied <- api_request(
    paste0(
      "https://www.googleapis.com/drive/v3/files/",
      source_form_id,
      "/copy"
    ),
    method = "POST",
    body = list(name = new_title, parents = source_meta$parents),
    token = token
  )

  publish_form(copied$id, token = token)

  form <- api_request(
    paste0("https://forms.googleapis.com/v1/forms/", copied$id),
    token = token
  )

  list(
    form_id = copied$id,
    edit_url = paste0("https://docs.google.com/forms/d/", copied$id, "/edit"),
    responder_url = form$responderUri
  )
}

# ---------------------------------------------------------------------------
# Usage: duplicate the day 6 exit tickets for day 7
# ---------------------------------------------------------------------------
# find_forms("Day 6")  # inspect results, grab the am/pm file ids you need
#
# am_ticket <- duplicate_exit_ticket(
#   source_form_id = "<day 6 AM exit ticket file id>",
#   new_title = "Day 7 AM Exit Ticket: Joining data"
# )
# pm_ticket <- duplicate_exit_ticket(
#   source_form_id = "<day 6 PM exit ticket file id>",
#   new_title = "Day 7 PM Exit Ticket: Reshaping data"
# )
#
# am_ticket$responder_url
# pm_ticket$responder_url
#
# Paste responder_url into course-materials/day7.qmd in place of FIXME.
#
# Note: responder_url is the full docs.google.com link, not a forms.gle
# short link like earlier days use -- Google's URL shortener isn't exposed
# by the API. To match the shorter style, open the form, click Send > the
# link icon > toggle "Shorten URL", and use that instead.
