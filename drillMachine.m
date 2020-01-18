format compact

%problem variables
maxDrillPoints = 50;
limit = 50;
distanceTraveled = 0;
pointsDrilled = 0;
blockEncountered = false;
startX = 0;%initial point X
startY = 0;%initial point Y
%startX and startY will not changed. 
startPointX = 0;%this will be updated as current node's X
startPointY = 0;%this will be updated as current node's Y
minDistanceIndex = 0;
closePointDistance = 0;
%read xlsx file into a table
dataTable = readtable('data.xlsx');
%I extracted X and Y points from table into 2 arrays called coordinateX and
%coordinateY
coordinateX = dataTable.X_coordinate;
coordinateY = dataTable.Y_coordinate; 
closePointX = coordinateX(1,:);
closePointY = coordinateY(1,:);
i=1;%used for iteration of finding closest point of starting point
k = 2; %will be used in iteration for finding closest point of the current point
%Manhattan distance is used for calculating distance
%Next step is to find closest point from the data points


while closePointX ~=0 && closePointY ~=0 %if we haven't returned to starting position
    
    minDistance = abs(coordinateX(1,:)-startPointX)+abs(coordinateY(1,:)-startPointY);
    while k <= limit %this loop finds close node of the current element       
             
          closePointDistance = abs(coordinateX(k,:)-startPointX)+abs(coordinateY(k,:)-startPointY);
          if minDistance >= closePointDistance
              closePointX = coordinateX(k,:);
              closePointY = coordinateY(k,:);
              blockEncountered = isBlockThere(closePointX, closePointY, startPointX, startPointY);
              if blockEncountered == false 
                  minDistance = closePointDistance;
                  minDistanceIndex = k;
                  k=k+1;
              end
              if blockEncountered == true
                  k=k+1;                 
              end         
         
          else 
                  k = k+1;      
          end
    end
   
    
    
    if pointsDrilled > 1 
        
        distanceFromStart = abs(coordinateX(minDistanceIndex,:)-0)+abs(coordinateY(minDistanceIndex,:)-0);
        if distanceFromStart < minDistance
            closePointX = 0;
            closePointY = 0;%return to starting point
            distanceTraveled = distanceTraveled + distanceFromStart;
        else
            pointsDrilled = pointsDrilled +1 ;
            k = 2;
            limit = limit - 1;
            distanceTraveled = distanceTraveled + minDistance; 
            startPointX =coordinateX(minDistanceIndex,:);
            startPointY =coordinateY(minDistanceIndex,:);
            coordinateX(minDistanceIndex,:) = []; % remove the drilled element from the array
            coordinateY(minDistanceIndex,:) = []; % remove the dirlled element from the array    
        end
          
    end 
    
    if pointsDrilled <=1 
            pointsDrilled = pointsDrilled +1 ;
            k = 2;
            limit = limit - 1;
            distanceTraveled = distanceTraveled + minDistance; 
            startPointX =coordinateX(minDistanceIndex,:);
            startPointY =coordinateY(minDistanceIndex,:);
            coordinateX(minDistanceIndex,:) = []; % remove the drilled element from the array
            coordinateY(minDistanceIndex,:) = []; % remove the dirlled element from the array 
        
    end
    
      
end



function block = isBlockThere(cpointX, cpointY, currentX, currentY)

    a=1;%it will be used for iteration
    %cpointX: x coordinate of the close point
    %cpointY: y coordinate of the close point
    %currentX: x coordinate of the starting point
    %currentY:y coordinate of the starting point
    blockTable = readtable('blocks.xlsx');
    blockX = blockTable.Xcoordinate;
    blockY = blockTable.Ycoordinate;
    blockWidth = blockTable.Width;
    blockHeight = blockTable.Height;
  
    while a<=20
        blockPointX = blockX(a,:);
        blockPointY = blockY(a,:);
        blockw = blockWidth(a,:);
        blockh = blockHeight(a,:);
        anotherCornerX = blockPointX + blockw;
        anotherCornerY = blockPointY + blockh;
        %Corners of the rectangle are:
        %(blockPointX, blockPointY)
        %(blockPointX, anotherCornerY)
        %(anotherCornerX, anotherCornerY);
        %(anotherCornerX, blockPointY);
        if ((cpointX<=anotherCornerX)&&(currentX<= anotherCornerX)&&(blockPointX<=currentX)) &&((currentY<=blockPointY)&&(anotherCornerY<=cpointY))
            block = true;   
            return;
            
        else                   
            a = a + 1;
        end
    end
    
    block = false;
    return;
    
end
