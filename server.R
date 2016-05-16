library( shiny )
library( ggplot2 )

shinyServer( function( input, output, session ) {
    
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
