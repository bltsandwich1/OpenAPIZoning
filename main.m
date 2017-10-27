%%API Zones
clc;clear;close all
PlotPlan = PlotLoad();

SlateKey = 0;
More = 1;
[Row,Col,l] = size(PlotPlan);
plant_Width=Col;
plant_Depth=Row;



while More ==1
Slate = 3*ones(plant_Depth,plant_Width);
Rows = [1:plant_Depth]'.*ones(plant_Depth,plant_Width);
Cols = [1:plant_Width].*ones(plant_Depth,plant_Width);

waitfor(msgbox({'You''ll now be asked to select',' 2 points that mark the corners' 'of the unit.' 'select the top left corner first'}))

image(PlotPlan)
XYs = floor(ginput(2));

TLC_x = XYs(1)
TLC_y = XYs(3)
BRC_x = XYs(2)
BRC_y = XYs(4)

max_x=max([TLC_x,BRC_x])
max_y=max([TLC_y,BRC_y])
min_x=min([TLC_x,BRC_x])
min_y=min([TLC_y,BRC_y])

offset1 = 100
offset2 = 200

%outer bound
corners = [max_y+offset2,max_x+offset2;min_y-offset2,max_x+offset2;min_y-offset2,min_x-offset2;max_y+offset2,min_x-offset2]
in_unit = inpolygon(Rows(:),Cols(:),corners(:,1),corners(:,2));
Slate(in_unit)=10;
%inner bound
corners = [max_y+offset1,max_x+offset1;min_y-offset1,max_x+offset1;min_y-offset1,min_x-offset1;max_y+offset1,min_x-offset1]
in_unit = inpolygon(Rows(:),Cols(:),corners(:,1),corners(:,2));
Slate(in_unit)=15;

%inside unit
corners = [max_y,max_x;max_y,min_x;min_y,min_x;min_y,max_x]
in_unit = inpolygon(Rows(:),Cols(:),corners(:,1),corners(:,2));
Slate(in_unit)=20;


%For inner curve
corn_curve = 10*ones(offset1);
for r = 1:length(corn_curve)
    for c = 1:length(corn_curve)
        if sqrt(r^2+c^2)<(offset2-offset1)
            corn_curve(r,c)=15;
        end
        
    end
end

BR_c = corn_curve;
BL_c = fliplr(corn_curve);
TR_c = flipud(corn_curve);
TL_c = fliplr(TR_c);
Slate(min_y-length(BR_c):min_y-1,min_x-length(BR_c):min_x-1)=TL_c;
Slate(max_y+1:max_y+length(BR_c),min_x-length(BR_c):min_x-1)=BL_c;
Slate(max_y+1:max_y+length(BR_c),max_x+1:max_x+length(BR_c))=BR_c;
Slate(min_y-length(BR_c):min_y-1,max_x+1:max_x+length(BR_c))=TR_c;


%For outer curve
corn_curve = 3*ones(offset2);
for r = 1:length(corn_curve)
    for c = 1:length(corn_curve)
        if sqrt(r^2+c^2)<(offset2)
            corn_curve(r,c)=10;
        end
        
    end
end

for r = 1:length(corn_curve)
    for c = 1:length(corn_curve)
        if sqrt(r^2+c^2)<(offset2-offset1)
            corn_curve(r,c)=15;
        end
        
    end
end

BR_c = corn_curve;
BL_c = fliplr(corn_curve);
TR_c = flipud(corn_curve);
TL_c = fliplr(TR_c);
Slate(min_y-length(BR_c):min_y-1,min_x-length(BR_c):min_x-1)=TL_c;
Slate(max_y+1:max_y+length(BR_c),min_x-length(BR_c):min_x-1)=BL_c;
Slate(max_y+1:max_y+length(BR_c),max_x+1:max_x+length(BR_c))=BR_c;
Slate(min_y-length(BR_c):min_y-1,max_x+1:max_x+length(BR_c))=TR_c;

SlateKey = SlateKey+1;
SavedSlates(:,:,SlateKey)=Slate;
More = menu('Would you like to add another unit?','yes','no')
end

Kernel = [-1,0,-1;0,8,0;-1,0,-1];
Test = max(SavedSlates,[],3);
Zones = conv2(Test,Kernel);

Unit = Zones(2:end-1,2:end-1)==80;
Zone_Near = Zones(2:end-1,2:end-1)==60;
Zone_Mid= Zones(2:end-1,2:end-1)==40;
Zone_Far= Zones(2:end-1,2:end-1)==12;

Reds = PlotPlan(:,:,1);
Greens = PlotPlan(:,:,2);
Blues = PlotPlan(:,:,3);

Reds(Unit) = Reds(Unit)*.5;
Greens(Zone_Near) = Greens(Zone_Near)*.4;
Greens(Zone_Mid) = Greens(Zone_Mid)*.75;

ZonedF = cat(3,Reds,Greens,Blues);

image(ZonedF);



















