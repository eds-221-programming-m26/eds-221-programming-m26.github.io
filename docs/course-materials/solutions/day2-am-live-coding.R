# Creating vectors

# Integers

# integer()
integer(5)

# Sequence operator
1:5

# seq() function
seq(1, 5)
seq(2004, 2024, by = 2)

# c() "combine"
c(1L, 2L, -1L)

# Sampling random numbers from a distribution
rpois(5, lambda = 10)

# Doubles (i.e., decimals)

# double()
double(5)

# c()
c(1, 2, -1)

# seq() function
seq(1, 5, by = 0.9)
seq(1, 5, length.out = 4)

# Random numbers
rnorm(5, mean = 5, sd = 2)

# Coercion
1L / 2L

# Characters

# character()
character(5)

# c()
c("R", "Python", "SQL")

# What happens if I drop the quotes?
c(R, Python, SQL)
# Without quotes, R interprets these as variables

# What is the type of this vector?
c("1", "2", "3")

# Logical

# logical()
logical(5)

# c()
c(TRUE, FALSE)
# This is useless

# Relational operators
5 > 1
5 > 3:6
"R" == "Python"

# Predicates (any function that returns logic)
3:6 > 2
all(3:6 > 2)

5:10 > 7
any(5:10 > 7)
