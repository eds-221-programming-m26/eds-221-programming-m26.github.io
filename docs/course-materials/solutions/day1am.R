# This is a comment, it starts with a pound sign

# An expression is a complete, self-contained 
# piece of code that R can evaluate

# These are all expressions
2024
coral <- "Porites"
sample(1:6, size = 1)

# We write code in a **script** (this document)
# We run code at the **console** (panel below)
# Code modifies the **environment** panel to the right

# For code to modify the environment, we have to assign the output 
# to a variable using <-
1:6
d6 <- 1:6

# What do you think these operators do?
5 + 2
3 * 2
5 > 2

# Math operators follow PEMDAS rules
1 + 2 * 3
(1 + 2) * 3
1 + (2 * 3)

# Run this code and decide if * or : has higher precendence
2 * 3 : 8


# Functions are triggered by parentheses
sample(d6, size = 1)

# What do you think this does?
sum(sample(d6, size = 2, replace = TRUE))

# If you want to work with text instead of numbers, use quotations
coral_genus <- "Porites"
# To create multiple text values, use c()
coral_genera <- c("Porites", "Acropora")
coral_genera
