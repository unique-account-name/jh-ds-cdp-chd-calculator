library( shiny )
library( ggplot2 )

# Define server logic required to draw a histogram
shinyServer( function( input, output, session ) {
   
    #output$foo <- renderPrint( "9135923459" )
    #output$value <- renderPrint({ input$action })
    # You can access the value of the widget with input$text, e.g.
    #output$text1 <- renderPrint({ input$risk_yours * 2 })
    #print( "asdfasdf" )
    
    #updateSliderInput( session, "age", value = 23 )#, min = floor(val/2), max = val+4, step = (val+1)%%2 + 1)
    
    #if ( input$health_choices ) {
        
        #updateSelectInput( session, "smoker", label = "Current smoker", choices = c( "No", "Yes" ), selected = "Yex" )
    #}
    
    # output$text1 <- renderText({ 
    #     paste("You have selected mitigating factor ", input$health_choices )
    # 
    # })
    # 
    # output$text2 <- renderText({ 
    #     paste( "This your updated risk: ", input$risk_yours )
    # })
    # output$text3 <- renderText({ 
    #     if ( input$smoker == "Yes" ) {
    #         paste( "You smoke.  Ick!" )
    #     } else {
    #         paste( "You don't smoke. Yay!" )
    #     }
    # })
    # output$text4 <- renderText({ 
    #     #input$action[ 1 ]
    #     paste( "last widget used: ", input$last_widget_used )
    # })
    
    output$risk_plot <- renderPlot({
      
        risk_type <- c( "Yours", "Optimal", "Average" )
        print( input$risk_yours )
        risk <- c( input$risk_yours, input$risk_optimal, input$risk_average )
        print( risk )
        risks_df <- data.frame( risk, as.factor( risk_type ) )
        print( risks_df )
        risk_plot <- ggplot( data = risks_df, aes( x = risk_type, y = risk, fill = risk_type ) ) +
            geom_bar( stat = "identity" ) +
            ggtitle( "10 Year Risk Window" ) +
            xlab( " " ) + ylab( "Risk %" ) +
            labs( fill = "Risk Profile" ) +
            geom_text( aes( label = risk ), vjust = 2 )
        risk_plot
    })
})
