library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
    tags$head( tags$script( src = "gencvd10_lipid_calc.js" ) ),
    
    h3( "Calculate Your Predicted Risk of Coronary Heart Disease (CHD)", a( "Instructions", href="instructions.html" ) ),
    hr(),
    
    fluidRow(
        column(3,
               selectInput( "gender", "Gender:",  choices = c( "Male", "Female" ) ) 
        ),
        column(3,
               selectInput( "trtbp", "Treated for hypertension:",  choices = c( "No", "Yes" ) )   
        ),
        column(3,
               selectInput( "smoker", "Current smoker:",  choices = c( "No", "Yes" ) )
        ),
        column(3,
               selectInput( "diabetes", "Diabetes:",  choices = c( "No", "Yes" ) )
        )
    ),
    fluidRow(
        column(3,
               sliderInput( "age", "Age:", min = 30, max = 74, value = 50, animate = TRUE )
        ),
        column(3,
               sliderInput( "sbp", "Systolic BP:", min = 90, max = 200, value = 132, animate = TRUE  )
        ),
        column(3,
               sliderInput( "hdl", "HDL:", min = 10, max = 100, value = 52, animate = TRUE  )
        ),
        column(3,
               sliderInput( "tcl", "Total cholesterol:", min = 100, max = 405, value = 237, animate = TRUE  )
        )
    ),
    hr(),
    fluidRow(
        column(6,
               plotOutput( "risk_plot" )
        ),
        column(6,
               # hide this input
               conditionalPanel(
                   condition = "1 == 0",
                   textInput( "last_widget_used", "Last widget", value = "none" ),
                   numericInput( "risk_yours", "Your risk %:", 0, min = 0, max = 100 ),
                   numericInput( "risk_average", "Average risk %:", NA, min = 0, max = 100 ),
                   numericInput( "risk_optimal", "Optimal risk %:", NA, min = 0, max = 100 )
               ),   
               p( strong( "Mitigating Factors: What You Can Do to Change Your Risk of CHD" ) ),
               p( "Smoking: Quit and lower your risk by ~50%" ),
               p( "Cardio: Exercise briskly 5x a week and lower your cholesterol" ),
               p( "Strength: Lift weights and raise your base metabolism" ), 
               p( "Diet: Lower your total cholesterol below 200" ),
               p( "Diet: Raise your HDL cholesterol over 60" ),
               p( "Diet: Reduce your sugar intake and reduce your risk of diabetes" ),
               p( "Drink: Wine in moderation (1-2 glasses daily) lowers cholesterol" ) 
        )
    )
))
