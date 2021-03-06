library(shiny)
library(fpp3)
library(ggplot2)
library(shinyWidgets)
library(quantmod)
library(plotly)
library(dplyr)
library(shinydashboard)
library(tidyquant)
library(flexdashboard)
library(feasts)
library(ggeasy)
library(ggthemes)
library(seasonal)
library(seasonalview)

# Path where data is
file_path <- "multiTimeline.csv"
# Data starts in 3rd row, skip first 2 rows
g_trends <- read.csv(file_path, skip = 2)
# Rename columns
names(g_trends) <- c("Month", "Interest")
# Convert Month to date
g_trends$Month <- yearmonth(g_trends$Month)
# Convert to tsibble
g_trends <- tsibble(g_trends)


ui <-
  dashboardPage( skin = "yellow",
                 dashboardHeader(title = "Interest in \"Tennessee Lady Vols\"", titleWidth = 500),
                 dashboardSidebar( width = 200,
                                   sidebarMenu(
                                     menuItem("Introduction", tabName = "intro", 
                                              icon = icon("dashboard")),
                                     menuItem("Full-Time Series", tabName = "graph1", 
                                              icon = icon("chart-line")),
                                     menuItem("Plot Choice", tabName = "graph2", 
                                              icon = icon("chart-line")),
                                     menuItem("Simple Models", tabName = "SimpleModels", 
                                              icon = icon("chart-line")),
                                     menuItem("Exponential Smoothing", tabName = "ETSmodels", 
                                              icon = icon("chart-line")),
                                     menuItem("ARIMA", tabName = "ARIMAmodels", 
                                              icon = icon("chart-line"))
                                   )
                 ),
                 dashboardBody(
                   tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Georgia", Times, "Times New Roman", serif;
        font-weight: bold;
        font-size: 24px;
      }
    '))),
                   
                   tabItems(
                     # First tab content
                     tabItem(tabName = "intro",
                             h1("Introduction"), 
                             
                             hr(),
                             
                             tags$div(
                               tags$h3("This application analyzes the interest in 
                                      \"Tennessee Lady Vols\" from data collected by 
                                      GoogleTrends."),
                               
                               tags$head(tags$style('h3 {color:#FF8200;}')),
                               
                               tags$br(),
                               
                               tags$h3("The second tab displays the Full-Time Series graphic for the interest in \"Tennessee Lady Vols\" from January 2004 to March 2022."),
                               
                               tags$br(),
                               
                               tags$h3("The third tab displays your choice in one of three types of graphics: (1) seasonality, (2) autocorrelation, and (3) decomposition. "),
                               
                               tags$br(),
                               
                               tags$h3("The fourth tab displays your choice in one of four types of simple model forecasts:"),
                               tags$h3("(1) Mean, (2) Naïve, (3) Seasonal Naïve, and (4) Drift"),
                               
                               tags$br(),
                               
                               tags$h3("The fifth tab displays your choice in one of two types of Exponential Smoothing forecasts: "),
                               tags$h3("(1) Holts or (2) Holts/Winters"),
                               
                               tags$br(),
                               
                               tags$h3("The sixth tab displays your choice in one of four types of ARIMA forecasts: "),
                               tags$h3("ARIMA(2,1,0), ARIMA(0,1,2)(0,1,1), ARIMA(2,1,0)(0,1,1), and (4) Autoselected ARIMA"),
                               
                               tags$br()
                               
                             ),
                             div(img(src = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/Tennessee_Lady_Volunteers_logo.svg/1200px-Tennessee_Lady_Volunteers_logo.svg.png",
                                     height = 200, width = 200),
                                 style="text-align: center;")
                             
                     ),
                     
                     # Second tab content
                     tabItem(tabName = "graph1",
                             h1("Full-Time Series Graph"),
                             
                             hr(),
                             
                             basicPage(
                               plotlyOutput("fulltimeseries")
                             ),
                             
                             hr(),
                             
                             h3("Interpretation"),
                             
                             h4("The full-time series shows a trend that was 
                                relatively increasing from 2004-2008.The trend
                                then appears to be decreasing from about
                                2009-2017. The trend then appears to increase 
                                from 2018-2022. There appears to be strong
                                seasonality throughtout the plot. This is 
                                likely due to basketball season.")
                             
                     ), 
                     
                     # Third tab content
                     tabItem(tabName = "graph2",
                             h1("Graphic of Your Choice"), 
                             
                             hr(),
                             
                             radioButtons("plot_type", 
                                          label = h3("Which plot do you want to see?"),
                                          choices = c("Seasonality", 
                                                      "Autocorrelation", 
                                                      "Decomposition")),
                             
                             hr(),
                             
                             plotOutput("myplot"),
                             
                             hr(),
                             
                             h3("Interpretation"),
                             
                             textOutput("myplotint")
                             
                     ),
                     
                     # Fourth tab content
                     tabItem(tabName = "SimpleModels",
                             h1("Forecast of Your Choice"),
                             
                             hr(),
                             
                             radioButtons("forecast_simpletype", 
                                          label = h3("Which type of forecast do you want to see?"),
                                          choices = c("Mean", 
                                                      "Naïve", 
                                                      "Seasonal Naïve", 
                                                      "Drift")),
                             
                             hr(),
                             
                             
                             plotOutput("forecast_simple")
                             
                             
                             
                     ),
                     
                     # Fifth tab content
                     tabItem(tabName = "ETSmodels",
                             h1("Forecast of Your Choice"),
                             
                             hr(),
                             
                             radioButtons("forecast_ETStype", 
                                          label = h3("Which type of forecast do you want to see?"),
                                          choices = c("Holts", 
                                                      "Holts/Winters")),
                             
                             hr(),
                             
                             
                             plotOutput("forecast_ETS")
                             
                             
                             
                     ),
                     
                     # Sixth tab content
                     tabItem(tabName = "ARIMAmodels",
                             h1("Forecast of Your Choice"),
                             
                             hr(),
                             
                             radioButtons("forecast_ARIMAtype", 
                                          label = h3("Which type of forecast do you want to see?"),
                                          choices = c("ARIMA(2,1,0)", 
                                                      "ARIMA(0,1,2)(0,1,1)", 
                                                      "ARIMA(2,1,0)(0,1,1)", 
                                                      "Autoselected ARIMA")),
                             
                             hr(),
                             
                             
                             plotOutput("forecast_ARIMA")
                             
                             
                             
                     )
                     
                   )  
                   
                 )
                 
  )



server <- function(input, output, session) {
  output$fulltimeseries <- renderPlotly({
    p <- ggplot(g_trends, aes(Month, Interest)) + 
      geom_line(color = "#22afff") + 
      theme_fivethirtyeight()+
      labs(title = "The Interest of \"Tennessee Lady Vols\"", y = "Interest") +
      ggeasy::easy_center_title() +
      ggeasy::easy_all_text_color(color = "#ff8200") +
      theme(plot.background = element_rect(fill = "white"), 
            panel.background = element_rect(fill = "white"))
    ggplotly(p)
  })
  
  output$myplot <- renderPlot({
    if (input$plot_type == "Seasonality") {
      g_trends %>% gg_season(Interest)+
        theme_fivethirtyeight()+
        labs(title = "The Interest of \"Tennessee Lady Vols\"", y = "Interest") +
        ggeasy::easy_center_title() +
        ggeasy::easy_all_text_color(color = "#ff8200") +
        theme(plot.background = element_rect(fill = "white"), 
              panel.background = element_rect(fill = "white"))
    } 
    else if (input$plot_type == "Autocorrelation") {
      g_trends %>% ACF() %>% 
        autoplot()+
        labs(title = "Interest of Tennessee Lady Vols")+
        ggeasy::easy_center_title()+
        ggeasy::easy_all_text_colour(colour = "#FF8200")+
        theme(plot.background = element_rect(fill = "white"), 
              panel.background = element_rect(fill = "white"))
    }
    else if (input$plot_type == "Decomposition") {
      x11_dcmp <- g_trends %>%
        model(x11 = X_13ARIMA_SEATS(Interest ~ x11())) %>%
        components()
      autoplot(x11_dcmp) +
        labs(title = "Decomposition of Interest of \"Tennessee Lady 
           Vols\" using X-11.")+
        ggeasy::easy_center_title()+
        ggeasy::easy_all_text_colour(colour = "#FF8200")+
        theme(plot.background = element_rect(fill = "white"), 
              panel.background = element_rect(fill = "white"))
    }
  })
  
  output$myplotint <- renderText({
    if (input$plot_type == "Seasonality") {
      noquote(paste(c("The seasonality plot shows that the interest 
      in \"Tennessee Lady Vols\" peaks from January until April and 
      again from November to December. This makes logical sense 
      because this coincides with basketball season. Also of note is 
      that June is particularly high for most of the summer months.
      This is likely due to the conclusion of softball season. The
      highest amount of interest seems to coincide with Tennessee's
      last two women's basketball national championships in 2007 and 
      2008.", 
                      collapse = " ")))
    } 
    else if (input$plot_type == "Autocorrelation") {
      noquote(paste(c("The autocorrelation plot shows that the 
      interest in \"Tennessee Lady Vols\" is extremely seasonal. This
      is likely due to basketball season and softball season. 
      This is especially the case for seasons that these two teams
      experience success.", collapse = " ")))
    }
    else if (input$plot_type == "Decomposition") {
      noquote(paste(c("The X11 decomposition plot shows that the trend
      peaked in about 2008. The plot also shows a consistent amount
      of seasonality.", collapse = " ")))
    }
    
    
  })
  
  output$forecast_simple <- renderPlot({
    if(input$forecast_simpletype == "Mean") {
      interest_fit <- g_trends %>%
        model(
          Mean = MEAN(Interest)
        )
      
      interest_fc <- interest_fit %>% forecast(h = 15)
      
      interest_fc %>%
        autoplot(g_trends, level = NULL) +
        autolayer(
          filter_index(g_trends, "2004 Jan" ~ .),
          colour = "#ff8200"
        ) +
        labs( y = "Interest",
              title = "Mean Forecast for interest in \"Tennessee Lady Vols\""
        ) + 
        guides(colour = guide_legend(title = "Forecast"))+
        ggeasy::easy_center_title()+
        ggeasy::easy_all_text_color(color = "#22afff")
    }
    else if(input$forecast_simpletype == "Naïve") {
      interest_fit <- g_trends %>%
        model(`Naïve` = NAIVE(Interest)
        )
      
      interest_fc <- interest_fit %>% forecast(h = 15)
      
      interest_fc %>%
        autoplot(g_trends, level = NULL) +
        autolayer(
          filter_index(g_trends, "2004 Jan" ~ .),
          colour = "#ff8200"
        ) +
        labs( y = "Interest",
              title = "Naïve Forecast for interest in \"Tennessee Lady Vols\""
        ) + 
        guides(colour = guide_legend(title = "Forecast"))+
        ggeasy::easy_center_title()+
        ggeasy::easy_all_text_color(color = "#22afff")
    }
    
    else if(input$forecast_simpletype == "Seasonal Naïve") {
      interest_fit <- g_trends %>%
        model(`Seasonal naïve` = SNAIVE(Interest)
        )
      
      interest_fc <- interest_fit %>% forecast(h = 15)
      
      interest_fc %>%
        autoplot(g_trends, level = NULL) +
        autolayer(
          filter_index(g_trends, "2004 Jan" ~ .),
          colour = "#ff8200"
        ) +
        labs( y = "Interest",
              title = "Seasonal Naïve Forecast for interest in \"Tennessee Lady Vols\""
        ) + 
        guides(colour = guide_legend(title = "Forecast"))+
        ggeasy::easy_center_title()+
        ggeasy::easy_all_text_color(color = "#22afff")
    }
    
    else if(input$forecast_simpletype == "Drift") {
      interest_fit <- g_trends %>%
        model(`Drift` = RW(Interest ~ drift())
        )
      
      interest_fc <- interest_fit %>% forecast(h = 15)
      
      interest_fc %>%
        autoplot(g_trends, level = NULL) +
        autolayer(
          filter_index(g_trends, "2004 Jan" ~ .),
          colour = "#ff8200"
        ) +
        labs( y = "Interest",
              title = "Drift Forecast for interest in \"Tennessee Lady Vols\""
        ) + 
        guides(colour = guide_legend(title = "Forecast"))+
        ggeasy::easy_center_title()+
        ggeasy::easy_all_text_color(color = "#22afff")
    }
    
  })
    
    output$forecast_ETS <- renderPlot({
      if(input$forecast_ETStype == "Holts") {
        interest_fit <- g_trends %>%
          model(
            Holts = ETS(Interest ~ error("A") + trend("A") + season("N"))
          )
        
        interest_fc <- interest_fit %>% forecast(h = 15)
        
        interest_fc %>%
          autoplot(g_trends, level = NULL) +
          autolayer(
            filter_index(g_trends, "2004 Jan" ~ .),
            colour = "#ff8200"
          ) +
          labs( y = "Interest",
                title = "Holts Forecast for interest in \"Tennessee Lady Vols\""
          ) + 
          guides(colour = guide_legend(title = "Forecast"))+
          ggeasy::easy_center_title()+
          ggeasy::easy_all_text_color(color = "#22afff")
      }
      else if(input$forecast_ETStype == "Holts/Winters") {
        interest_fit <- g_trends %>%
          model(`Holts/Winters` = ETS(Interest ~ error("A") + trend("A") 
                                      + season("A")))
        
        interest_fc <- interest_fit %>% forecast(h = 15)
        
        interest_fc %>%
          autoplot(g_trends, level = NULL) +
          autolayer(
            filter_index(g_trends, "2004 Jan" ~ .),
            colour = "#ff8200"
          ) +
          labs( y = "Interest",
                title = "Holts/Winters Forecast for interest in \"Tennessee Lady Vols\""
          ) + 
          guides(colour = guide_legend(title = "Forecast"))+
          ggeasy::easy_center_title()+
          ggeasy::easy_all_text_color(color = "#22afff")
      }
      
      
    })
    
  
    output$forecast_ARIMA <- renderPlot({
      if(input$forecast_ARIMAtype == "ARIMA(2,1,0)") {
        interest_fit <- g_trends %>%
          model(arima210 = ARIMA(Interest ~ pdq(2,1,0))
                )
        
        interest_fc <- interest_fit %>% forecast(h = 15)
        
        interest_fc %>%
          autoplot(g_trends, level = NULL) +
          autolayer(
            filter_index(g_trends, "2004 Jan" ~ .),
            colour = "#ff8200"
          ) +
          labs( y = "Interest",
                title = "ARIMA(2,1,0) Forecast for interest in \"Tennessee Lady Vols\""
          ) + 
          guides(colour = guide_legend(title = "Forecast"))+
          ggeasy::easy_center_title()+
          ggeasy::easy_all_text_color(color = "#22afff")
      }
      else if(input$forecast_ARIMAtype == "ARIMA(0,1,2)(0,1,1)") {
        interest_fit <- g_trends %>%
          model(
           ARIMA(Interest ~ pdq(0,1,2)+PDQ(0,1,1))
          )
        
        interest_fc <- interest_fit %>% forecast(h = 15)
        
        interest_fc %>%
          autoplot(g_trends, level = NULL) +
          autolayer(
            filter_index(g_trends, "2004 Jan" ~ .),
            colour = "#ff8200"
          ) +
          labs( y = "Interest",
                title = "ARIMA(0,1,2)(0,1,1) Forecast for interest in \"Tennessee Lady Vols\""
          ) + 
          guides(colour = guide_legend(title = "Forecast"))+
          ggeasy::easy_center_title()+
          ggeasy::easy_all_text_color(color = "#22afff")
      }
      else if(input$forecast_ARIMAtype == "ARIMA(2,1,0)(0,1,1)") {
        interest_fit <- g_trends %>%
          model(
            ARIMA(Interest ~ pdq(2,1,0)+PDQ(0,1,1))
          )
        
        interest_fc <- interest_fit %>% forecast(h = 15)
        
        interest_fc %>%
          autoplot(g_trends, level = NULL) +
          autolayer(
            filter_index(g_trends, "2004 Jan" ~ .),
            colour = "#ff8200"
          ) +
          labs( y = "Interest",
                title = "ARIMA(2,1,0)(0,1,1) Forecast for interest in \"Tennessee Lady Vols\""
          ) + 
          guides(colour = guide_legend(title = "Forecast"))+
          ggeasy::easy_center_title()+
          ggeasy::easy_all_text_color(color = "#22afff")
      }
      
      else if(input$forecast_ARIMAtype == "Autoselected ARIMA") {
        interest_fit <- g_trends %>%
          model(
            ARIMA(Interest)
          )
        
        interest_fc <- interest_fit %>% forecast(h = 15)
        
        interest_fc %>%
          autoplot(g_trends, level = NULL) +
          autolayer(
            filter_index(g_trends, "2004 Jan" ~ .),
            colour = "#ff8200"
          ) +
          labs( y = "Interest",
                title = "Autoselected ARIMA Forecast for interest in \"Tennessee Lady Vols\""
          ) + 
          guides(colour = guide_legend(title = "Forecast"))+
          ggeasy::easy_center_title()+
          ggeasy::easy_all_text_color(color = "#22afff")
      }
      
    })
    
    
}
shinyApp(ui, server)
