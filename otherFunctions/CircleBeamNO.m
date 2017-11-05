function [circled_bm]=CircleBeamNO(elem_cd, elem_mp, inclusion)
%%-------------------------------------------------------------------------

% INPUT: elem_coords; 
% OUTPUT: selected bms by circled_bms
bm_cd=[];

%build the column of bm_cd
for i_bm_cd=1:size(elem_mp(:,1))
    x1=elem_cd(i_bm_cd,1);
    y1=elem_cd(i_bm_cd,2);
    x2=elem_cd(i_bm_cd,3);
    y2=elem_cd(i_bm_cd,4);
    %for any two nodes, find out a series of values which have interval
    %accuracy(acc)
    bm_cd_x=linspace(x1,x2,inclusion.acc);
    bm_cd_y=linspace(y1,y2,inclusion.acc);
    bm_cd=[bm_cd;[bm_cd_x; bm_cd_y]'];
end
distance=sqrt((bm_cd(:,2)-inclusion.cy).^2+(bm_cd(:,1)-inclusion.cx).^2);
%distance between center and mid-coords

segment=distance<inclusion.r;

circled_bm_location=[];

for i_ccl_bm=1:size(elem_mp(:,1))
    segments=segment((inclusion.acc*(i_ccl_bm-1)+1):(i_ccl_bm*inclusion.acc));
    true=any(segments);%''any''returns 1 if any of the () is nonzero, 0 if 
    %all is 0
    circled_bm_location=[circled_bm_location;true];
end

circled_bm=find(circled_bm_location==1);

%-------------------------------------------------------------------------
