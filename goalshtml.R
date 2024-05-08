


library(ggplot2)
library(RCurl)
library(htmltools)

encodeGraphic <- function(g) {
  png(tf1 <- tempfile(fileext = ".png"))  # Save the plot as a PNG file
  print(g)  # Print the plot to the file
  dev.off()  # Close the file
  
  txt <- RCurl::base64Encode(readBin(tf1, "raw", file.info(tf1)[1, "size"]), "txt")  # Encode the PNG file as base64
  myImage <- htmltools::HTML(sprintf('<img src="data:image/png;base64,%s">', txt))  # Convert the base64 string to an HTML image object
  
  return(myImage)
}
HTMLOut <- "C:/Users/Admin/OneDrive/Desktop/output1.html"  # Specify the path where you want to save the HTML file

library(readxl)
Data <- read_excel("C:/Users/Admin/Downloads/Premier League 2011-12 Match by Match.xls")
print(head(Data))
library(dplyr)
unique_values <- unique(Data$Team)


# Assuming 'Data' is your dataframe
team_goals <- Data %>%
  group_by(Team) %>%
  summarise(Total_Goals = sum(Goals))

# Define a named vector for team name abbreviations
team_name_abbreviations <- c(
  "Manchester United" = "MUFC",
  "Liverpool" = "LFC",
  "Chelsea" = "CHE",
  "Arsenal" = "ARS",
  "Tottenham Hotspur" = "TOT"
  # Add more team names and their abbreviations as needed
)

# Function to shorten team names using the named vector
shorten_team_names <- function(team_name) {
  # Use the named vector to replace full team names with abbreviations
  return(team_name_abbreviations[team_name])
}

# Plot with shortened team names
g<-ggplot(team_goals, aes(x = Team, y = Total_Goals, fill = Team)) +
  geom_bar(stat = "identity") +
  labs(x = "Team", y = "Total Goals", fill = "Team") +
  theme_minimal() +
  scale_x_discrete(labels = shorten_team_names) # Use the function to shorten team names

# Convert the ggplot2 plot to an HTML image object
hg <- encodeGraphic(g)

# Create the HTML content
forHTML <- list(
  h1("ALL GOALS ANALYTICS IN PERMIER LEAUGE 2011-2012"),
  p("Analyzing the total goals scored in the Premier League for the 2011-2012 season using R programming "),
  hg
)

# Save the HTML content to a file
save_html(forHTML, HTMLOut)


