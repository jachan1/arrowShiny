function(input, output, session) {
  
  output$text <- renderText({
    # getArrow generates the points LiveCycle wants
    # getArrow is defined in global.r
    outList <- getArrow(startX = input$startX, 
                        startY = input$startY, 
                        Hor = input$Hor, 
                        Pos = input$Pos,
                        arrowH = input$arrowH, 
                        angle = input$arrowA,
                        Len = input$Len)
    sprintf("Line 1: X: %1.4f, Y: %1.4f, Width: %1.4f, Height: %1.4f\nLine 2: X: %1.4f, Y: %1.4f, Width: %1.4f, Height: %1.4f", 
                  outList$X1, outList$Y1, outList$width, outList$height,
                  outList$X2, outList$Y2, outList$width, outList$height)
  })
  
  output$plot <- renderPlot({
    # getArrow generates the points for LiveCycle
    # this function needs to translate those points into actual coordinate geometry
    outList <- getArrow(startX = input$startX, 
                        startY = input$startY, 
                        Hor = input$Hor, 
                        Pos = input$Pos,
                        arrowH = input$arrowH, 
                        angle = input$arrowA,
                        Len = input$Len)
    
    # these nested if statements could likely be simplified with the use of ifelse assignments
    # however this should be easier to read/debug
    # y axis are reversed with ylim to accomodate LiveCycle reference frame
    if (input$Hor == 1) {
      if (input$Pos == 1) {
        xlim = c(input$startX, outList$endX)
        ylim = c(input$startY + abs(diff(xlim))/3.5, input$startY - abs(diff(xlim))/3.5)
        segSx1 = xlim[1]
        segSy1 = segSy2 = input$startY
        segSx2 = xlim[2]
        
        end = list(x = xlim[2], y = input$startY)
        adj1=c(1,0)
        adj2=c(1,1)
        
        seg1x = outList$X1
        seg1y = outList$Y1
        seg2x = outList$X2
        seg2y = outList$Y2 + outList$height
      } else {
        xlim = c(input$startX, input$startX + input$Len)
        ylim = c(input$startY + abs(diff(xlim))/3.5, input$startY - abs(diff(xlim))/3.5)
        segSx1 = xlim[1]
        segSy1 = segSy2 = input$startY
        segSx2 = xlim[2]
        
        end = list(x = xlim[1],  y = input$startY)
        adj1=c(0,0)
        adj2=c(0,1)
        
        seg1x = outList$X1 + outList$width
        seg1y = outList$Y1
        seg2x = outList$X2 + outList$width
        seg2y = outList$Y2 + outList$height
      }
    } else {
      if (input$Pos == 1) {
        ylim = c(outList$endY, input$startY)
        xlim = c(input$startX - abs(diff(ylim))/1.5, input$startX + abs(diff(ylim))/1.5)
        
        segSy1 = ylim[1]
        segSx1 = segSx2 = input$startX
        segSy2 = ylim[2]
        
        end = list(x = input$startX,  y = ylim[1])
        adj1=c(1,0)
        adj2=c(0,0)
        
        seg1x = outList$X1
        seg1y = outList$Y1
        seg2x = outList$X2 + outList$width
        seg2y = outList$Y2 
      } else {
        ylim = c(input$startY + input$Len, input$startY)
        xlim = c(input$startX - abs(diff(ylim))/1.5, input$startX + abs(diff(ylim))/1.5)
        segSy1 = ylim[1]
        segSx1 = segSx2 = input$startX
        segSy2 = ylim[2]
        
        end = list(x = input$startX,  y = ylim[2])
        adj1=c(1,1)
        adj2=c(0,1)        
        
        seg1x = outList$X1
        seg1y = outList$Y1 + outList$height
        seg2x = outList$X2 + outList$width
        seg2y = outList$Y2 + outList$height
      }
    }
    plot(x=NULL,
         y=NULL,
         xlim=xlim,
         ylim=ylim,
         xlab="", ylab="", xaxt='n', yaxt='n')
    
    segments(segSx1, segSy1, segSx2, segSy2, col= 'blue', lwd=3)
    
    segments(seg1x, seg1y, end$x, end$y, col= 'blue', lwd=3)
    text(seg1x, seg1y, "1", cex = 1.5, adj = adj1)
    segments(seg2x, seg2y, end$x, end$y, col= 'blue', lwd=3)
    text(seg2x, seg2y, "2", cex = 1.5, adj = adj2)
  })
}