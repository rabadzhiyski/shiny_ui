aggregate_time_series <-
    function(data, time_unit) {
        
        output_tbl <- data %>%
            
            mutate(date = floor_date(order.date, unit = time_unit)) %>%
            
            group_by(date) %>%
            summarize(total_sales = sum(extended_price)) %>%
            ungroup() %>%
            
            mutate(label_text = str_glue("Date: {date}
                                 Revenue: {scales::dollar(total_sales)}"))
        
        output_tbl
    }
plot_time_series <-
    function(data) {
        
        g <- data %>%
            
            ggplot(aes(date, total_sales)) +
            
            geom_line(color = "#2c3e50") +
            geom_point(aes(text = label_text), color = "#2c3e50", size = 0.1) +
            geom_smooth(method = "loess", span = 0.2) +
            
            theme_tq() +
            expand_limits(y = 0) +
            scale_y_continuous(labels = scales::dollar_format()) +
            labs(x = "", y = "")
        
        
        ggplotly(g)
        
        
    }
aggregate_geospatial <- 
    function(data) {
        data %>%
            group_by(state) %>%
            summarise(total_revenue = sum(extended_price)) %>%
            ungroup() %>%
            mutate(label_text = str_glue("State: {state}
                                 Revenue: {scales::dollar(total_revenue)}"))
    }
plot_geospatial <- 
    function(data) {
        data %>%
            plot_geo(locationmode = "USA-states") %>%
            add_trace(z         = ~total_revenue, 
                      locations = ~state, 
                      color     = ~total_revenue,
                      text      = ~label_text,
                      colors    = "Blues") %>%
            layout(
                geo = list(
                    scope = "usa",
                    projection = list(type = "albers usa"),
                    showlakes  = TRUE,
                    lakecolor  = toRGB("white")
                ),
                paper_bgcolor = 'rgba(0,0,0,0)',
                plot_bgcolor  = 'rgba(0,0,0,0)'
            )
    }
