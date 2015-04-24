# shinyapps::deployApp("P:/Documents/RWD/arrowShiny/arrowShiny")

fluidPage(
  # Application title
  titlePanel("LiveCycle Arrow"),
  
  sidebarLayout(
    # Sidebar with a slider and selection inputs
    sidebarPanel(
      p("Arrow angle and Height define the shape of the arrow (these don't need to be changed)"),
      numericInput("arrowA", "Arrow Angle:", 30, min=0, step = 5),
      numericInput("arrowH", "Arrow Height:", 0.1, min=0, step=0.1),
      hr(),
      p("To start, draw the main line in LiveCycle and change the details below accordingly"),
      p("Orientation and Direction are set for the main line"),
      selectInput("Hor", "Orientation:",
                  choices = dirHor),
      selectInput("Pos", "Direction:", 
                  choices = dirPos),
      p("X and Y are taken from the layout tab for the main line"),
      numericInput("startX", "X:", 1, min=0),
      numericInput("startY", "Y:", 1, min=0),
      p("From the layout tab for the main line Length is: Width for a horizontal line or Height for a vertical line"),
      numericInput("Len", "Length:", 1, min=0)
    ),
    
    # Arrow Details
    mainPanel(
      plotOutput("plot"),
      titlePanel("Line attributes for LiveCycle"),
      verbatimTextOutput("text"),
      p("In LiveCycle create the two lines for the arrow in roughly the correct place and then enter the details above into the layout for each line")
    )
  )
)