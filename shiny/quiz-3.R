description <- function(name, age, gender, likes_r) {
  gender_desc <- switch(gender,
    Male = "man",
    Female = "female",
    Other = "person"
  )

  paste0(name, " is a ", age, " year old ", gender_desc,
    " who ", if (likes_r) "likes" else "doesn't like", " R")
}
description("Hadley", 35, "Male", TRUE)
description("Emily", 10, "Female", FALSE)
