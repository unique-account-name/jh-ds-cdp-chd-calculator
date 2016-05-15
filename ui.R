#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    tags$head( tags$script( src = "gencvd10_lipid_calc.js" ) ),
    
    # Application title
    titlePanel( "Calculate Your Predicted Risk of Coronary Heart Disease (CHD)" ),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            p( a( "Instructions", href="instructions.html" ) ),
            selectInput( "gender", "Gender:",  choices = c( "Male", "Female" ) ),
            
            sliderInput( "age", "Age:", min = 30, max = 74, value = 54, animate = TRUE ),
            
            sliderInput( "sbp", "Systolic BP:", min = 90, max = 200, value = 127, animate = TRUE  ),
            
            selectInput( "trtbp", "Treated for hypertension:",  choices = c( "No", "Yes" ) ),
            
            selectInput( "smoker", "Current smoker:",  choices = c( "No", "Yes" ) ),
            
            selectInput( "diabetes", "Diabetes:",  choices = c( "No", "Yes" ) ),
            
            sliderInput( "hdl", "HDL:", min = 10, max = 100, value = 52, animate = TRUE  ),
            
            sliderInput( "tcl", "Total cholesterol:", min = 100, max = 405, value = 217, animate = TRUE  )
        ),
        
        
        # Show a plot of the generated distribution
        mainPanel(
            
            # plot!
            plotOutput( "risk_plot" ),
            #actionButton( "action", label = "F00!" ),
            
            # hide this input
            conditionalPanel(
                condition = "1 == 0",
                textInput( "last_widget_used", "Last widget", value = "none" ),
                numericInput( "risk_yours", "Your risk %:", 0, min = 0, max = 100 ),
                numericInput( "risk_average", "Average risk %:", NA, min = 0, max = 100 ),
                numericInput( "risk_optimal", "Optimal risk %:", NA, min = 0, max = 100 )
            ),
            
            #textInput( "bar", label = h3( "Your Risk" ), value = "" ),
            #hr(),
            #fluidRow( column( 12, verbatimTextOutput( "foo" ) ) )
            #fluidRow( verbatimTextOutput( "foo" ) ),
            
            # textOutput( "text1" ),
            # textOutput( "text2" ),
            # textOutput( "text3" ),
            # textOutput( "text4" ),
            # checkboxGroupInput( "health_choices", label = h3( "Reduce Your Risk" ),
            #                     choices = list(
            #                         "Smoking: Quit and lower your risk by ~50%" = 1,
            #                         "Cardio: Exercise briskly 5x a week and lower your cholesterol" = 2,
            #                         "Strength: Lift weights and raise your base metabolism", 3, 
            #                         "Diet: Lower your total cholesterol below 200" = 4,
            #                         "Diet: Raise your HDL cholesterol over 60" = 5,
            #                         "Diet: Reduce your sugar intake and reduce your risk of diabetes" = 6,
            #                         "Drink: Wine in moderation (1-2 glasses daily) lowers cholesterol" = 7,
            #                     selected = 0 )
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

#$("#age").val()
#$("#gender").val()
