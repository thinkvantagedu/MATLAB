function [N, Nxi, Neta, Nzeta, NZN] = ShapeFunc(eType,pospg)
%
% [N,Nxi,Neta] = ShapeFunc(dim, elem,nen,pospg)
% Computes the values of the shape functions and its detivatives.
%
% Input:
%   eType:    Element Type
%   pospg:    Coordinates of Gauss points in the reference element
%
% Output:
%   N, Nxi, Neta, Nzeta: matrices storing the values of the shape functions on the
%                        Gauss points of the reference element.
%                        Each row concerns to a Gauss point
%

xi = pospg(:,1);
if size(pospg,2) > 1
    eta = pospg(:,2);
end
if size(pospg,2) > 2
    zeta = pospg(:,3);
end

if strcmp ('Tetra10',eType)
    if size(pospg,2) > 3
        ZN = pospg(:,4);
    elseif size(pospg,2) == 3
        ZN=(1-xi-eta-zeta);
    else
        error('pospg (position of gauss points) needs 3 or 4 tetraedral natural coordinates')
    end
end

vect0 = zeros(size(xi));
vect1 = ones(size(xi));

switch eType
    %   Numbering as gmsh
    %
    %     1--3--4--2
    
    case 'Line2'
        N =   [(1-xi)/2,           (1+xi)/2];
        Nxi = [-ones(size(xi))/2,  ones(size(xi))/2];
    case 'Line3'
        N =   [xi.*(xi-1)/2,  xi.*(xi+1)/2,  (1+xi).*(1-xi)];
        Nxi = [xi-1/2,        xi+1/2,        -2*xi     ];
    case 'Line4'
        N   = [-1/16*(xi-1).*( 3*xi-1).*( 3*xi+1),   1/16*(3*xi-1).*( 3*xi+1).*( xi+1), ...
            9/16*(xi-1).*( 3*xi-1).*( xi+1)       -9/16*(xi-1).*( 3*xi+1).*( xi+1)    ];
        Nxi = [1/16+9/8*xi-27/16*xi.^2,              -1/16+9/8*xi+27/16*xi.^2
            -27/16-9/8*xi+81/16*xi.^2             27/16-9/8*xi-81/16*xi.^2         ];
        
        %   Numbering as gmsh
        %
        %             ^ eta
        %             |
        %       4-----7-----3
        %       |'    |     |
        %       |  '  |     |
        %       8     9-----6--> xi
        %       |           |
        %       |       '   |
        %       1-----5-----2
        
        
    case {'Quad1', 'PlateQuad1'}
        N    = vect1;
        Nxi  = vect0;
        Neta = vect0;
    case {'Quad4', 'PlateQuad4'} % Q1
        N    = [(1-xi).*(1-eta)/4, (1+xi).*(1-eta)/4, ...
            (1+xi).*(1+eta)/4, (1-xi).*(1+eta)/4];
        Nxi  = [(eta-1)/4, (1-eta)/4, (1+eta)/4, -(1+eta)/4];
        Neta = [(xi-1)/4, -(1+xi)/4,   (1+xi)/4,  (1-xi)/4 ];
    case {'Quad9','PlateQuad9'} % Q2
        N    = [xi.*(xi-1).*eta.*(eta-1)/4, xi.*(xi+1).*eta.*(eta-1)/4, ...
            xi.*(xi+1).*eta.*(eta+1)/4, xi.*(xi-1).*eta.*(eta+1)/4, ...
            (1-xi.^2).*eta.*(eta-1)/2,  xi.*(xi+1).*(1-eta.^2)/2,   ...
            (1-xi.^2).*eta.*(eta+1)/2,  xi.*(xi-1).*(1-eta.^2)/2,   ...
            (1-xi.^2).*(1-eta.^2)];
        Nxi  = [(xi-1/2).*eta.*(eta-1)/2,   (xi+1/2).*eta.*(eta-1)/2, ...
            (xi+1/2).*eta.*(eta+1)/2,   (xi-1/2).*eta.*(eta+1)/2, ...
            -xi.*eta.*(eta-1),          (xi+1/2).*(1-eta.^2),   ...
            -xi.*eta.*(eta+1),          (xi-1/2).*(1-eta.^2),   ...
            -2*xi.*(1-eta.^2)];
        Neta = [xi.*(xi-1).*(eta-1/2)/2,    xi.*(xi+1).*(eta-1/2)/2, ...
            xi.*(xi+1).*(eta+1/2)/2,    xi.*(xi-1).*(eta+1/2)/2, ...
            (1-xi.^2).*(eta-1/2),       xi.*(xi+1).*(-eta),   ...
            (1-xi.^2).*(eta+1/2),       xi.*(xi-1).*(-eta),   ...
            (1-xi.^2).*(-2*eta)];
    case {'Quad8','PlateQuad8'} % Q2_serendipity
        N    = [(-0.25)*(1-xi).*(1-eta).*(1+xi+eta), ...
            (-0.25)*(1+xi).*(1-eta).*(1-xi+eta), ...
            (-0.25)*(1+xi).*(1+eta).*(1-xi-eta), ...
            (-0.25)*(1-xi).*(1+eta).*(1+xi-eta), ...
            (0.5)*(1-xi.*xi).*(1-eta), ...
            (0.5)*(1-eta.*eta).*(1+xi), ...
            (0.5)*(1-xi.*xi).*(1+eta), ...
            (0.5)*(1-eta.*eta).*(1-xi)  ];
        Nxi  = [(-0.25)*(-eta-2*xi+2*xi.*eta+eta.*eta), ...
            (-0.25)*(eta-2*xi+2*xi.*eta-eta.*eta), ...
            (-0.25)*(-eta-2*xi-2*xi.*eta-eta.*eta), ...
            (-0.25)*(eta-2*xi-2*xi.*eta+eta.*eta), ...
            -xi.*(1-eta), ...
            (0.5)*(1-eta.*eta), ...
            -xi.*(1+eta), ...
            (0.5)*(eta.*eta-1)];
        Neta = [(-0.25)*(-xi-2*eta+xi.*xi+2*xi.*eta), ...
            (-0.25)*(xi-2*eta+xi.*xi-2*xi.*eta), ...
            (-0.25)*(-xi-2*eta-xi.*xi-2*xi.*eta), ...
            (-0.25)*(xi-2*eta-xi.*xi+2*xi.*eta), ...
            (0.5)*(xi.*xi-1), ...
            -eta.*(1+xi), ...
            (0.5)*(1-xi.*xi), ...
            -eta.*(1-xi)];
    case {'Quad16','PlateQuad16'} % Q3
        c0=3^6;
        c1=c0/(2*4*6*2*4*6);
        c2=c0/(2*4*6*2*2*4);
        c3=c0/(2*2*4*2*2*4);
        xi_1=          (xi+1/3).*(xi-1/3).*(xi-1)*(-1);
        xi_1_3=(xi+1).*          (xi-1/3).*(xi-1)*(1);
        xi1_3= (xi+1).*(xi+1/3).*          (xi-1)*(-1);
        xi1=   (xi+1).*(xi+1/3).*(xi-1/3)        *(1);
        eta_1=          (eta+1/3).*(eta-1/3).*(eta-1)*(-1);
        eta_1_3=(eta+1).*          (eta-1/3).*(eta-1)*(1);
        eta1_3= (eta+1).*(eta+1/3).*          (eta-1)*(-1);
        eta1=   (eta+1).*(eta+1/3).*(eta-1/3)        *(1);
        
        N    = [c1*  xi_1  .*  eta_1  , ...
            c1*  xi1   .*  eta_1  , ...
            c1*  xi1   .*  eta1   , ...
            c1*  xi_1  .*  eta1   , ...
            c2*  xi_1_3.*  eta_1  , ...
            c2*  xi1_3 .*  eta_1  , ...
            c2*  xi1   .*  eta_1_3, ...
            c2*  xi1   .*  eta1_3 , ...
            c2*  xi1_3 .*  eta1   , ...
            c2*  xi_1_3.*  eta1   , ...
            c2*  xi_1  .*  eta1_3 , ...
            c2*  xi_1  .*  eta_1_3, ...
            c3*  xi_1_3.*  eta_1_3, ...
            c3*  xi1_3 .*  eta_1_3, ...
            c3*  xi_1_3.*  eta1_3 , ...
            c3*  xi1_3 .*  eta1_3 , ...
            ];
        dxi_1=  (3*xi.^2 - 2*xi     - 1/9)*(-1);
        dxi_1_3=(3*xi.^2 - (2/3)*xi - 1  )*(1);
        dxi1_3= (3*xi.^2 + (2/3)*xi - 1  )*(-1);
        dxi1=   (3*xi.^2 + 2*xi     - 1/9)*(1);
        Nxi  = [c1*  dxi_1  .*  eta_1  , ...
            c1*  dxi1   .*  eta_1  , ...
            c1*  dxi1   .*  eta1   , ...
            c1*  dxi_1  .*  eta1   , ...
            c2*  dxi_1_3.*  eta_1  , ...
            c2*  dxi1_3 .*  eta_1  , ...
            c2*  dxi1   .*  eta_1_3, ...
            c2*  dxi1   .*  eta1_3 , ...
            c2*  dxi1_3 .*  eta1   , ...
            c2*  dxi_1_3.*  eta1   , ...
            c2*  dxi_1  .*  eta1_3 , ...
            c2*  dxi_1  .*  eta_1_3, ...
            c3*  dxi_1_3.*  eta_1_3, ...
            c3*  dxi1_3 .*  eta_1_3, ...
            c3*  dxi_1_3.*  eta1_3 , ...
            c3*  dxi1_3 .*  eta1_3 , ...
            ];
        deta_1=  (3*eta.^2 - 2*eta     - 1/9)*(-1);
        deta_1_3=(3*eta.^2 - (2/3)*eta - 1  )*(1);
        deta1_3= (3*eta.^2 + (2/3)*eta - 1  )*(-1);
        deta1=   (3*eta.^2 + 2*eta     - 1/9)*(1);
        Neta = [c1*  xi_1  .*  deta_1  , ...
            c1*  xi1   .*  deta_1  , ...
            c1*  xi1   .*  deta1   , ...
            c1*  xi_1  .*  deta1   , ...
            c2*  xi_1_3.*  deta_1  , ...
            c2*  xi1_3 .*  deta_1  , ...
            c2*  xi1   .*  deta_1_3, ...
            c2*  xi1   .*  deta1_3 , ...
            c2*  xi1_3 .*  deta1   , ...
            c2*  xi_1_3.*  deta1   , ...
            c2*  xi_1  .*  deta1_3 , ...
            c2*  xi_1  .*  deta_1_3, ...
            c3*  xi_1_3.*  deta_1_3, ...
            c3*  xi1_3 .*  deta_1_3, ...
            c3*  xi_1_3.*  deta1_3 , ...
            c3*  xi1_3 .*  deta1_3 , ...
            ];
        
        %   Numbering as gmsh
        %       3
        %       |'\
        %       |  '\
        %       6    5
        %       |  7  '\
        %       |       '\
        %       1----4----2
        
    case {'Tria1','PlateTria1'}
        N    = vect1;
        Nxi  = vect0;
        Neta = vect0;
    case {'Tria3','PlateTria3'} % P1
        N    = [1-(xi+eta),xi,eta];
        Nxi  = [-vect1, vect1, vect0];
        Neta = [-vect1, vect0, vect1];
    case {'Tria6','PlateTria6'} % P2
        N    = [(1-2*(xi+eta)).*(1-(xi+eta)),  xi.*(2*xi-1),  eta.*(2*eta-1),  4*xi.*(1-(xi+eta)),  4*xi.*eta,  4*eta.*(1-(xi+eta))];
        Nxi  = [-3+4*(xi+eta),                 4*xi-1,        vect0,           4*(1-2*xi-eta),      4*eta,      -4*eta];
        Neta = [-3+4*(xi+eta),                 vect0,         4*eta-1,         -4*xi,               4*xi,       4*(1-xi-2*eta)];
    case {'Tria4','PlateTria4'} % P1+
        N    = [1-(xi+eta),  xi,    eta,   27*xi.*eta.*(1-xi-eta)];
        Nxi  = [-vect1,      vect1, vect0, 27*eta.*(1-2*xi-eta)];
        Neta = [-vect1,      vect0, vect1, 27*xi.*(1-2*eta-xi)];
    case {'Tria7','PlateTria7'} % P2+
        N    = [(1-2*(xi+eta)).*(1-(xi+eta)),  xi.*(2*xi-1),  eta.*(2*eta-1), ...
            4*xi.*(1-(xi+eta)),            4*xi.*eta,     4*eta.*(1-(xi+eta)),     27*xi.*eta.*(1-xi-eta)];
        Nxi  = [-3+4*(xi+eta),                 4*xi-1,        vect0, ...
            4*(1-2*xi-eta),                4*eta,         -4*eta,                  27*eta.*(1-2*xi-eta)];
        Neta = [-3+4*(xi+eta),                 vect0,         4*eta-1, ...
            -4*xi,                         4*xi,          4*(1-xi-2*eta),          27*xi.*(1-2*eta-xi)];
        
        %  Numbering as gmsh
        %  TETRAHEDRON SCHEME, FOR SHAPE FUNCTIONS.
        %
        %     4
        %     |\\
        %     | \ \
        %     |  \  9
        %     8   \    \
        %     |    \     \
        %     |     \  __-- 3
        %     |  _ 7-\"    |
        %    1 <"     10   |
        %        \     \   |
        %          \    \  6
        %            5   \ |
        %              \  \|
        %                \ |
        %                  2
        %
        
    case 'Tetra1'
        N    = vect1;
        Nxi  = vect0;
        Neta = vect0;
        Nzeta = vect0;
    case 'Tetra4'
        N    = [1-(xi+eta+zeta), xi,eta, zeta ];
        Nxi  = [-vect1, vect1, vect0, vect0];
        Neta = [-vect1, vect0, vect1, vect0];
        Nzeta = [-vect1, vect0, vect0, vect1];
        
    case 'Tetra10_infructuous_attempt'
        ZA=(1-xi-eta-zeta);
        N    = [ZA.*(2*ZA-1),  xi.*(2*xi-1),  eta.*(2*eta-1),  zeta.*(2*zeta-1), ...
            4*ZA.*xi,      4*xi.*eta,     4*eta.*ZA,  ...
            4*ZA.*zeta,    4*xi.*zeta,    4*eta.*zeta  ];
        
        Nxi  = [(1-4*ZA),      (4*xi-1),      vect0,           vect0,  ...
            4*(ZA-xi),     4*eta,         -4*eta, ...
            -4*zeta,       4*zeta,        vect0   ];
        
        Neta = [(1-4*ZA),      vect0,         (4*eta-1),       vect0,  ...
            -4*xi,         4*xi,          4*(ZA-eta), ...
            -4*zeta,       vect0,         4*zeta  ];
        
        Nzeta =[(1-4*ZA),      vect0,         vect0,           (4*zeta-1),  ...
            -4*xi,         vect0,         -4*eta, ...
            4*(ZA-zeta),   4*xi,          4*eta   ];
        
    case 'Tetra10'
        
        N    = [ZN.*(2*ZN-1),  xi.*(2*xi-1),  eta.*(2*eta-1),  zeta.*(2*zeta-1), ...
            4*ZN.*xi,      4*xi.*eta,     4*eta.*ZN,  ...
            4*ZN.*zeta,    4*xi.*zeta,    4*eta.*zeta  ];
        
        Nxi  = [vect0,         (4*xi-1),      vect0,           vect0,  ...
            4*ZN,          4*eta,         vect0,  ...
            vect0,         4*zeta,        vect0   ];
        
        Neta = [vect0,         vect0,         (4*eta-1),       vect0,  ...
            vect0,         4*xi,          4*ZN,   ...
            vect0,         vect0,         4*zeta  ];
        
        Nzeta =[vect0,         vect0,         vect0,           (4*zeta-1),  ...
            vect0,         vect0,         vect0, ...
            4*ZN,          4*xi,          4*eta   ];
        
        NZN =  [(4*ZN-1),      vect0,         vect0,            vect0,  ...
            4*xi,          vect0,         4*eta , ...
            4*zeta,        vect0,         vect0   ];
        
    case 'Tetra10old'
        N    = [(1-xi-eta-zeta).*(1-2*xi-2*eta-2*zeta), xi.*(2*xi-1), eta.*(2*eta-1), zeta.*(2*zeta-1), ...
            4*xi.*(1-xi-eta-zeta), 4*xi.*eta, 4*eta.*(1-xi-eta-zeta), 4*zeta.*(1-xi-eta-zeta),  ...
            4*eta.*zeta, 4*xi.*zeta ];
        Nxi  = [4*(xi+eta+zeta)-3, 4*xi-1, vect0, vect0, ...
            4*(1-2*xi-eta-zeta), 4*eta, -4*eta, -4*zeta,  ...
            vect0, 4*zeta ];
        Neta = [4*(xi+eta+zeta)-3, vect0, 4*eta-1, vect0, ...
            -4*xi, 4*xi, 4*(1-xi-2*eta-zeta), -4*zeta, ...
            4*zeta, vect0 ];
        Nzeta = [4*(xi+eta+zeta)-3, vect0, vect0, 4*zeta-1, ...
            -4*xi, vect0 , -4*eta, 4*(1-xi-eta-2*zeta), ...
            4*eta, 4*xi ];
        
    case 'Tetra10_kk'
        ZA=(1-xi-eta-zeta); ZB=xi; ZC=eta; ZD=zeta;
        dZAxi=-vect1; dZBxi=vect1; dZCxi=vect0; dZDxi=vect0;
        dZAeta=-vect1; dZBeta=vect0; dZCeta=vect1; dZDeta=vect0;
        dZAzeta=-vect1; dZBzeta=vect0; dZCzeta=vect0; dZDzeta=vect1;
        N    = [ZA.*(2*ZA-1),  ZB.*(2*ZB-1),  ZC.*(2*ZC-1),  ZD.*(2*ZD-1), ...
            4*ZA.*ZB,      4*ZB.*ZC,      4*ZC.*ZA,  ...
            4*ZA.*ZD,      4*ZB.*ZD,      4*ZC.*ZD  ];
        
        Nxi  = [(4*ZA-1).*dZAxi+0+0+0,                        0+(4*ZB-1).*dZBxi+0+0,  ...
            0+0+(4*ZC-1).*dZCxi+0,                        0+0+0+(4*ZD-1).*dZDxi,  ...
            (4*ZB).*dZAxi + (4*ZA).*dZBxi + 0 + 0 ,       0 + (4*ZC).*dZBxi + (4*ZB).*dZCxi + 0,  ...
            (4*ZC).*dZAxi + 0 + (4*ZA).*dZCxi + 0 ,       (4*ZD).*dZAxi + 0 + 0 + (4*ZA).*dZDxi,  ...
            0 + (4*ZD).*dZBxi + 0 + (4*ZB).*dZDxi ,       0 + 0 + (4*ZD).*dZCxi + (4*ZC).*dZDxi   ];
        Neta = [(4*ZA-1).*dZAeta+0+0+0,                       0+(4*ZB-1).*dZBeta+0+0,  ...
            0+0+(4*ZC-1).*dZCeta+0,                       0+0+0+(4*ZD-1).*dZDeta,  ...
            (4*ZB).*dZAeta + (4*ZA).*dZBeta + 0 + 0 ,     0 + (4*ZC).*dZBeta + (4*ZB).*dZCeta + 0,  ...
            (4*ZC).*dZAeta + 0 + (4*ZA).*dZCeta + 0 ,     (4*ZD).*dZAeta + 0 + 0 + (4*ZA).*dZDeta,  ...
            0 + (4*ZD).*dZBeta + 0 + (4*ZB).*dZDeta ,     0 + 0 + (4*ZD).*dZCeta + (4*ZC).*dZDeta   ];
        Nzeta =[(4*ZA-1).*dZAzeta+0+0+0,                      0+(4*ZB-1).*dZBzeta+0+0,  ...
            0+0+(4*ZC-1).*dZCzeta+0,                      0+0+0+(4*ZD-1).*dZDzeta,  ...
            (4*ZB).*dZAzeta + (4*ZA).*dZBzeta + 0 + 0 ,   0 + (4*ZC).*dZBzeta + (4*ZB).*dZCzeta + 0,  ...
            (4*ZC).*dZAzeta + 0 + (4*ZA).*dZCzeta + 0 ,   (4*ZD).*dZAzeta + 0 + 0 + (4*ZA).*dZDzeta,  ...
            0 + (4*ZD).*dZBzeta + 0 + (4*ZB).*dZDzeta ,   0 + 0 + (4*ZD).*dZCzeta + (4*ZC).*dZDzeta   ];
        
        
        
        %  TRIANGULAR NON EXTRUDED PRISM SCHEME, FOR SHAPE FUNCTIONS
        %
        %
        % LINEAR
        %
        %    4-----------6
        %    |\         /|
        %    | \       / |
        %    |  \     /  |
        %  (7)   \   /  (9)
        %    |    \ /    |
        %    |     5     |
        %    |     |     |
        %    1-----+-----3
        %     \    |    /
        %      \  (8)  /
        %       \  |  /
        %        \ | /
        %         \|/
        %          2
        %           \
        %            \Xi axis
        %
        % QUADRATIC                              |zeta axis
        %                                        |
        %    4-----12----6    (16, 17 , 18       |···········x(0,1,1)
        %    |\         /|     are the mid       |·         ·:
        %    | \       / |     points of the     | ·       · :
        %    |  10    11 |     quadrilaterals)   |  ·     ·  :
        %  (13)  \   /  (15)              (0,0,0)o--------------Eta
        %    |    \ /    |                       :\   · ·    :
        %    |     5     |                       : \   ·     :
        %    |     |     |                       :  \  :     :
        %    1----9+-----3               (0,0,-1)x···\·:·····x(0,1,-1)
        %     \    |    /                         ·   \:    ·
        %      \  (14) /                           ·   \   ·
        %       7  |  8                             ·  :\ ·
        %        \ | /                               · : \
        %         \|/                                 ·:· \
        %          2                          (1,0,-1) x   \Xi
        %           \
        %            \Xi axis
        %
    case 'PrismT1'
        N    = vect1;
        Nxi  = vect0;
        Neta = vect0;
        Nzeta = vect0;
    case 'PrismT3-2'
        N    = [(1-(xi+eta)).*(1-zeta)/2  , xi.*(1-zeta)/2, eta.*(1-zeta)/2, ...
            (1-(xi+eta)).*(1+zeta)/2  , xi.*(1+zeta)/2, eta.*(1+zeta)/2];
        Nxi  = [-(1-zeta)/2, (1-zeta)/2, vect0, -(1+zeta)/2, (1+zeta)/2, vect0];
        Neta = [-(1-zeta)/2, vect0, (1-zeta)/2,  -(1+zeta)/2, vect0, (1+zeta)/2];
        Nzeta = [-(1-(xi+eta))/2  , -xi/2, -eta/2, (1-(xi+eta))/2  , xi/2, eta/2];
        
    case 'PrismT6-2'
        N    = [((1-2*(xi+eta)).*(1-(xi+eta))).*(1-zeta)/2,   (xi.*(2*xi-1)).*(1-zeta)/2 ,   (eta.*(2*eta-1)).*(1-zeta)/2, ...
            ((1-2*(xi+eta)).*(1-(xi+eta))).*(1+zeta)/2,   (xi.*(2*xi-1)).*(1+zeta)/2 ,   (eta.*(2*eta-1)).*(1+zeta)/2, ...
            (4*xi.*(1-(xi+eta))).*(1-zeta)/2,             (4*xi.*eta).*(1-zeta)/2,       (4*eta.*(1-(xi+eta))).*(1-zeta)/2, ...
            (4*xi.*(1-(xi+eta))).*(1+zeta)/2,             (4*xi.*eta).*(1+zeta)/2,       (4*eta.*(1-(xi+eta))).*(1+zeta)/2];
        Nxi  = [(-3+4*(xi+eta)).*(1-zeta)/2,                  (4*xi-1).*(1-zeta)/2,          vect0, ...
            (-3+4*(xi+eta)).*(1+zeta)/2,                  (4*xi-1).*(1+zeta)/2,          vect0, ...
            (4*(1-2*xi-eta)).*(1-zeta)/2,                 4*eta.*(1-zeta)/2,             -4*eta.*(1-zeta)/2, ...
            (4*(1-2*xi-eta)).*(1+zeta)/2,                 4*eta.*(1+zeta)/2,             -4*eta.*(1+zeta)/2 ];
        Neta = [ (-3+4*(xi+eta)).*(1-zeta)/2,         Extruded         vect0,                         (4*eta-1).*(1-zeta)/2, ...
            (-3+4*(xi+eta)).*(1+zeta)/2,                  vect0,                         (4*eta-1).*(1+zeta)/2, ...
            -4*xi.*(1-zeta)/2,                            4*xi.*(1-zeta)/2,              (4*(1-xi-2*eta)).*(1-zeta)/2, ...
            -4*xi.*(1+zeta)/2,                            4*xi.*(1+zeta)/2,              (4*(1-xi-2*eta)).*(1+zeta)/2];
        Nzeta = [-((1-2*(xi+eta)).*(1-(xi+eta)))./2,   -(xi.*(2*xi-1))./2 ,   -(eta.*(2*eta-1))./2, ...
            ((1-2*(xi+eta)).*(1-(xi+eta)))./2,    (xi.*(2*xi-1))./2 ,    (eta.*(2*eta-1))./2, ...
            -(4*xi.*(1-(xi+eta)))./2,             -(4*xi.*eta)./2,       -(4*eta.*(1-(xi+eta)))./2, ...
            (4*xi.*(1-(xi+eta)))./2,              (4*xi.*eta)./2,        (4*eta.*(1-(xi+eta)))./2];
    case 'PrismT6-3'
        N    = [((1-2*(xi+eta)).*(1-(xi+eta))).*(zeta.*(zeta-1)/2), (xi.*(2*xi-1)).*(zeta.*(zeta-1)/2), (eta.*(2*eta-1)).*(zeta.*(zeta-1)/2), ...
            ((1-2*(xi+eta)).*(1-(xi+eta))).*(zeta.*(zeta+1)/2), (xi.*(2*xi-1)).*(zeta.*(zeta+1)/2), (eta.*(2*eta-1)).*(zeta.*(zeta+1)/2), ...
            (4*xi.*(1-(xi+eta))).*(zeta.*(zeta-1)/2),           (4*xi.*eta).*(zeta.*(zeta-1)/2),    (4*eta.*(1-(xi+eta))).*(zeta.*(zeta-1)/2), ...
            (4*xi.*(1-(xi+eta))).*(zeta.*(zeta+1)/2),           (4*xi.*eta).*(zeta.*(zeta+1)/2),    (4*eta.*(1-(xi+eta))).*(zeta.*(zeta+1)/2) ...
            ((1-2*(xi+eta)).*(1-(xi+eta))).*(1-zeta.^2),        (xi.*(2*xi-1)).*(1-zeta.^2) ,       (eta.*(2*eta-1)).*(1-zeta.^2), ...
            (4*xi.*(1-(xi+eta))).*(1-zeta.^2),                  (4*xi.*eta).*(1-zeta.^2),           (4*eta.*(1-(xi+eta))).*(1-zeta.^2)];
        Nxi  = [(-3+4*(xi+eta)).*(zeta.*(zeta-1)/2),       (4*xi-1).*(zeta.*(zeta-1)/2),    vect0, ...
            (-3+4*(xi+eta)).*(zeta.*(zeta+1)/2),       (4*xi-1).*(zeta.*(zeta+1)/2),    vect0, ...
            (4*(1-2*xi-eta)).*(zeta.*(zeta-1)/2),      4*eta.*(zeta.*(zeta-1)/2),       -4*eta.*(zeta.*(zeta-1)/2), ...
            (4*(1-2*xi-eta)).*(zeta.*(zeta+1)/2),      4*eta.*(zeta.*(zeta+1)/2),       -4*eta.*(zeta.*(zeta+1)/2), ...
            (-3+4*(xi+eta)).*(1-zeta.^2),              (4*xi-1).*(1-zeta.^2),           vect0, ...
            (4*(1-2*xi-eta)).*(1-zeta.^2),             4*eta.*(1-zeta.^2),              -4*eta.*(1-zeta.^2)];
        Neta = [(-3+4*(xi+eta)).*(zeta.*(zeta-1)/2),       vect0,                           (4*eta-1).*(zeta.*(zeta-1)/2), ...
            (-3+4*(xi+eta)).*(zeta.*(zeta+1)/2),       vect0,                           (4*eta-1).*(zeta.*(zeta+1)/2), ...
            -4*xi.*(zeta.*(zeta-1)/2),                 4*xi.*(zeta.*(zeta-1)/2),        (4*(1-xi-2*eta)).*(zeta.*(zeta-1)/2), ...
            -4*xi.*(zeta.*(zeta+1)/2),                 4*xi.*(zeta.*(zeta+1)/2),        (4*(1-xi-2*eta)).*(zeta.*(zeta+1)/2), ...
            (-3+4*(xi+eta)).*(1-zeta.^2),              vect0,                           (4*eta-1).*(zeta.*(1-zeta.^2)), ...
            -4*xi.*(1-zeta.^2),                        4*xi.*(1-zeta.^2),               (4*(1-xi-2*eta)).*(1-zeta.^2)];
        Nzeta = [((1-2*(xi+eta)).*(1-(xi+eta))).*((2*zeta-1)/2),  (xi.*(2*xi-1)).*((2*zeta-1)/2), (eta.*(2*eta-1)).*((2*zeta-1)/2), ...
            ((1-2*(xi+eta)).*(1-(xi+eta))).*((2*zeta+1)/2),  (xi.*(2*xi-1)).*((2*zeta+1)/2), (eta.*(2*eta-1)).*(zeta.*(zeta+1)/2), ...
            (4*xi.*(1-(xi+eta))).*((2*zeta-1)/2),            (4*xi.*eta).*((2*zeta-1)/2),    (4*eta.*(1-(xi+eta))).*((2*zeta-1)/2), ...
            (4*xi.*(1-(xi+eta))).*((2*zeta+1)/2),            (4*xi.*eta).*((2*zeta+1)/2),    (4*eta.*(1-(xi+eta))).*((2*zeta+1)/2) ...
            ((1-2*(xi+eta)).*(1-(xi+eta))).*(-2*zeta),       (xi.*(2*xi-1)).*(-2*zeta) ,     (eta.*(2*eta-1)).*(-2*zeta), ...
            (4*xi.*(1-(xi+eta))).*(-2*zeta),                 (4*xi.*eta).*(-2*zeta),         (4*eta.*(1-(xi+eta))).*(-2*zeta)];
        
        % EXTRUDED PRISMS
        % QUADRATIC                              |zeta axis
        %                                        |
        %    7-----12----9    (16, 17 , 18       |···········x(0,1,1)
        %    |\         /|     are the mid       |·         ·:
        %    | \       / |     points of the     | ·       · :
        %    |  10    11 |     quadrilaterals)   |  ·     ·  :
        %  (13)  \   /  (15)              (0,0,0)o--------------Eta
        %    |    \ /    |                       :\   · ·    :
        %    |     8     |                       : \   ·     :
        %    |     |     |                       :  \  :     :
        %    1----6+-----3               (0,0,-1)x···\·:·····x(0,1,-1)
        %     \    |    /                         ·   \:    ·
        %      \  (14) /                           ·   \   ·
        %       4  |  5                             ·  :\ ·
        %        \ | /                               · : \
        %         \|/                                 ·:· \
        %          2                          (1,0,-1) x   \Xi
        %           \
        %            \Xi axis
        %
    case 'PrismT6-2Extruded'
        N    = [((1-2*(xi+eta)).*(1-(xi+eta))).*(1-zeta)/2,   (xi.*(2*xi-1)).*(1-zeta)/2 ,   (eta.*(2*eta-1)).*(1-zeta)/2, ...
            (4*xi.*(1-(xi+eta))).*(1-zeta)/2,             (4*xi.*eta).*(1-zeta)/2,       (4*eta.*(1-(xi+eta))).*(1-zeta)/2, ...
            ((1-2*(xi+eta)).*(1-(xi+eta))).*(1+zeta)/2,   (xi.*(2*xi-1)).*(1+zeta)/2 ,   (eta.*(2*eta-1)).*(1+zeta)/2, ...
            (4*xi.*(1-(xi+eta))).*(1+zeta)/2,             (4*xi.*eta).*(1+zeta)/2,       (4*eta.*(1-(xi+eta))).*(1+zeta)/2];
        Nxi  = [(-3+4*(xi+eta)).*(1-zeta)/2,                  (4*xi-1).*(1-zeta)/2,          vect0, ...
            (4*(1-2*xi-eta)).*(1-zeta)/2,                 4*eta.*(1-zeta)/2,             -4*eta.*(1-zeta)/2, ...
            (-3+4*(xi+eta)).*(1+zeta)/2,                  (4*xi-1).*(1+zeta)/2,          vect0, ...
            (4*(1-2*xi-eta)).*(1+zeta)/2,                 4*eta.*(1+zeta)/2,             -4*eta.*(1+zeta)/2 ];
        Neta = [(-3+4*(xi+eta)).*(1-zeta)/2,                  vect0,                         (4*eta-1).*(1-zeta)/2, ...
            -4*xi.*(1-zeta)/2,                            4*xi.*(1-zeta)/2,              (4*(1-xi-2*eta)).*(1-zeta)/2, ...
            (-3+4*(xi+eta)).*(1+zeta)/2,                  vect0,                         (4*eta-1).*(1+zeta)/2, ...
            -4*xi.*(1+zeta)/2,                            4*xi.*(1+zeta)/2,              (4*(1-xi-2*eta)).*(1+zeta)/2];
        Nzeta = [-((1-2*(xi+eta)).*(1-(xi+eta)))./2,   -(xi.*(2*xi-1))./2 ,   -(eta.*(2*eta-1))./2, ...
            -(4*xi.*(1-(xi+eta)))./2,             -(4*xi.*eta)./2,       -(4*eta.*(1-(xi+eta)))./2, ...
            ((1-2*(xi+eta)).*(1-(xi+eta)))./2,    (xi.*(2*xi-1))./2 ,    (eta.*(2*eta-1))./2, ...
            (4*xi.*(1-(xi+eta)))./2,              (4*xi.*eta)./2,        (4*eta.*(1-(xi+eta)))./2];
    case 'PrismT6-3Extruded'
        N    = [((1-2*(xi+eta)).*(1-(xi+eta))).*(zeta.*(zeta-1)/2), (xi.*(2*xi-1)).*(zeta.*(zeta-1)/2), (eta.*(2*eta-1)).*(zeta.*(zeta-1)/2), ...
            (4*xi.*(1-(xi+eta))).*(zeta.*(zeta-1)/2),           (4*xi.*eta).*(zeta.*(zeta-1)/2),    (4*eta.*(1-(xi+eta))).*(zeta.*(zeta-1)/2), ...
            ((1-2*(xi+eta)).*(1-(xi+eta))).*(zeta.*(zeta+1)/2), (xi.*(2*xi-1)).*(zeta.*(zeta+1)/2), (eta.*(2*eta-1)).*(zeta.*(zeta+1)/2), ...
            (4*xi.*(1-(xi+eta))).*(zeta.*(zeta+1)/2),           (4*xi.*eta).*(zeta.*(zeta+1)/2),    (4*eta.*(1-(xi+eta))).*(zeta.*(zeta+1)/2) ...
            ((1-2*(xi+eta)).*(1-(xi+eta))).*(1-zeta.^2),        (xi.*(2*xi-1)).*(1-zeta.^2) ,       (eta.*(2*eta-1)).*(1-zeta.^2), ...
            (4*xi.*(1-(xi+eta))).*(1-zeta.^2),                  (4*xi.*eta).*(1-zeta.^2),           (4*eta.*(1-(xi+eta))).*(1-zeta.^2)];
        Nxi  = [(-3+4*(xi+eta)).*(zeta.*(zeta-1)/2),       (4*xi-1).*(zeta.*(zeta-1)/2),    vect0, ...
            (4*(1-2*xi-eta)).*(zeta.*(zeta-1)/2),      4*eta.*(zeta.*(zeta-1)/2),       -4*eta.*(zeta.*(zeta-1)/2), ...
            (-3+4*(xi+eta)).*(zeta.*(zeta+1)/2),       (4*xi-1).*(zeta.*(zeta+1)/2),    vect0, ...
            (4*(1-2*xi-eta)).*(zeta.*(zeta+1)/2),      4*eta.*(zeta.*(zeta+1)/2),       -4*eta.*(zeta.*(zeta+1)/2), ...
            (-3+4*(xi+eta)).*(1-zeta.^2),              (4*xi-1).*(1-zeta.^2),           vect0, ...
            (4*(1-2*xi-eta)).*(1-zeta.^2),             4*eta.*(1-zeta.^2),              -4*eta.*(1-zeta.^2)];
        Neta = [(-3+4*(xi+eta)).*(zeta.*(zeta-1)/2),       vect0,                           (4*eta-1).*(zeta.*(zeta-1)/2), ...
            -4*xi.*(zeta.*(zeta-1)/2),                 4*xi.*(zeta.*(zeta-1)/2),        (4*(1-xi-2*eta)).*(zeta.*(zeta-1)/2), ...
            (-3+4*(xi+eta)).*(zeta.*(zeta+1)/2),       vect0,                           (4*eta-1).*(zeta.*(zeta+1)/2), ...
            -4*xi.*(zeta.*(zeta+1)/2),                 4*xi.*(zeta.*(zeta+1)/2),        (4*(1-xi-2*eta)).*(zeta.*(zeta+1)/2), ...
            (-3+4*(xi+eta)).*(1-zeta.^2),              vect0,                           (4*eta-1).*(zeta.*(1-zeta.^2)), ...
            -4*xi.*(1-zeta.^2),                        4*xi.*(1-zeta.^2),               (4*(1-xi-2*eta)).*(1-zeta.^2)];
        Nzeta = [((1-2*(xi+eta)).*(1-(xi+eta))).*((2*zeta-1)/2),  (xi.*(2*xi-1)).*((2*zeta-1)/2), (eta.*(2*eta-1)).*((2*zeta-1)/2), ...
            (4*xi.*(1-(xi+eta))).*((2*zeta-1)/2),            (4*xi.*eta).*((2*zeta-1)/2),    (4*eta.*(1-(xi+eta))).*((2*zeta-1)/2), ...
            ((1-2*(xi+eta)).*(1-(xi+eta))).*((2*zeta+1)/2),  (xi.*(2*xi-1)).*((2*zeta+1)/2), (eta.*(2*eta-1)).*(zeta.*(zeta+1)/2), ...
            (4*xi.*(1-(xi+eta))).*((2*zeta+1)/2),            (4*xi.*eta).*((2*zeta+1)/2),    (4*eta.*(1-(xi+eta))).*((2*zeta+1)/2) ...
            ((1-2*(xi+eta)).*(1-(xi+eta))).*(-2*zeta),       (xi.*(2*xi-1)).*(-2*zeta) ,     (eta.*(2*eta-1)).*(-2*zeta), ...
            (4*xi.*(1-(xi+eta))).*(-2*zeta),                 (4*xi.*eta).*(-2*zeta),         (4*eta.*(1-(xi+eta))).*(-2*zeta)];
        
        %     % NUMBERING ON GMSH, +1 for Matlab
        %     % Hexahedron:             Hexahedron20:          Hexahedron27:
        %     %
        %     %        eta
        %     % 3----------2            3----13----2           3----13----2
        %     % |\     ^   |\           |\         |\          |\         |\
        %     % | \    |   | \          | 15       | 14        |15    24  | 14
        %     % |  \   |   |  \         9  \       11 \        9  \ 20    11 \
        %     % |   7------+---5        |   7----19+---6       |   7----19+---6
        %     % |   |  +-- |-- | ->xi   |   |      |   |       |22 |  26  | 23|
        %     % 0---+---\--1   |        0---+-8----1   |       0---+-8----1   |
        %     %  \  |    \  \  |         \  17      \  18       \ 17    25 \  18
        %     %   \ |     \  \ |         10 |        12|        10 |  21    12|
        %     %    \|    zeta \|           \|         \|          \|         \|
        %     %     4----------5            4----16----5           4----16----5
        
        
        
    case {'Hexa8'}
        N    = [(1-xi).*(1-eta).*(1-zeta)/8,   (1+xi).*(1-eta).*(1-zeta)/8, ...
            (1+xi).*(1+eta).*(1-zeta)/8,   (1-xi).*(1+eta).*(1-zeta)/8, ...
            (1-xi).*(1-eta).*(1+zeta)/8,   (1+xi).*(1-eta).*(1+zeta)/8, ...
            (1+xi).*(1+eta).*(1+zeta)/8,   (1-xi).*(1+eta).*(1+zeta)/8 ];
        Nxi  = [-1*(1-eta).*(1-zeta)/8,        (1-eta).*(1-zeta)/8, ...
            (1+eta).*(1-zeta)/8,           -1*(1+eta).*(1-zeta)/8, ...
            -1*(1-eta).*(1+zeta)/8,        (1-eta).*(1+zeta)/8, ...
            (1+eta).*(1+zeta)/8,           -1*(1+eta).*(1+zeta)/8 ];
        Neta = [(1-xi).*(-1).*(1-zeta)/8,      (1+xi).*(-1).*(1-zeta)/8, ...
            (1+xi).*(1-zeta)/8,            (1-xi).*(1-zeta)/8, ...
            (1-xi).*(-1).*(1+zeta)/8,      (1+xi).*(-1).*(1+zeta)/8, ...
            (1+xi).*(1+zeta)/8,            (1-xi).*(1+zeta)/8 ];
        Nzeta= [(1-xi).*(1-eta).*(-1)/8,       (1+xi).*(1-eta).*(-1)/8, ...
            (1+xi).*(1+eta).*(-1)/8,       (1-xi).*(1+eta).*(-1)/8, ...
            (1-xi).*(1-eta)/8,             (1+xi).*(1-eta)/8, ...
            (1+xi).*(1+eta)/8,             (1-xi).*(1+eta)/8 ];
        
    case {'Hexa27gmsh'}
        N    = [xi.*(xi-1).*eta.*(eta-1).*zeta.*(zeta-1)/8,    xi.*(xi+1).*eta.*(eta-1).*zeta.*(zeta-1)/8, ...
            xi.*(xi+1).*eta.*(eta+1).*zeta.*(zeta-1)/8,    xi.*(xi-1).*eta.*(eta+1).*zeta.*(zeta-1)/8, ...
            xi.*(xi-1).*eta.*(eta-1).*zeta.*(zeta+1)/8,    xi.*(xi+1).*eta.*(eta-1).*zeta.*(zeta+1)/8, ...
            xi.*(xi+1).*eta.*(eta+1).*zeta.*(zeta+1)/8,    xi.*(xi-1).*eta.*(eta+1).*zeta.*(zeta+1)/8, ...
            (1-xi.^2).*eta.*(eta-1).*zeta.*(zeta-1)/4,     xi.*(xi-1).*(1-eta.^2).*zeta.*(zeta-1)/4,   ...
            xi.*(xi-1).*eta.*(eta-1).*(1-zeta.^2)/4,       xi.*(xi+1).*(1-eta.^2).*zeta.*(zeta-1)/4,   ...
            xi.*(xi+1).*eta.*(eta-1).*(1-zeta.^2)/4,       (1-xi.^2).*eta.*(eta+1).*zeta.*(zeta-1)/4,  ...
            xi.*(xi+1).*eta.*(eta+1).*(1-zeta.^2)/4,       xi.*(xi-1).*eta.*(eta+1).*(1-zeta.^2)/4,    ...
            (1-xi.^2).*eta.*(eta-1).*zeta.*(zeta+1)/4,     xi.*(xi-1).*(1-eta.^2).*zeta.*(zeta+1)/4,   ...
            xi.*(xi+1).*(1-eta.^2).*zeta.*(zeta+1)/4,      (1-xi.^2).*eta.*(eta+1).*zeta.*(zeta+1)/4,  ...
            (1-xi.^2).*(1-eta.^2).*zeta.*(zeta-1)/2,       (1-xi.^2).*eta.*(eta-1).*(1-zeta.^2)/2,     ...
            xi.*(xi-1).*(1-eta.^2).*(1-zeta.^2)/2,         xi.*(xi+1).*(1-eta.^2).*(1-zeta.^2)/2,      ...
            (1-xi.^2).*eta.*(eta+1).*(1-zeta.^2)/2,        (1-xi.^2).*(1-eta.^2).*zeta.*(zeta+1)/2,    ...
            (1-xi.^2).*(1-eta.^2).*(1-zeta.^2)];
        Nxi  = [(2*xi-1).*eta.*(eta-1).*zeta.*(zeta-1)/8,      (2*xi+1).*eta.*(eta-1).*zeta.*(zeta-1)/8, ...
            (2*xi+1).*eta.*(eta+1).*zeta.*(zeta-1)/8,      (2*xi-1).*eta.*(eta+1).*zeta.*(zeta-1)/8, ...
            (2*xi-1).*eta.*(eta-1).*zeta.*(zeta+1)/8,      (2*xi+1).*eta.*(eta-1).*zeta.*(zeta+1)/8, ...
            (2*xi+1).*eta.*(eta+1).*zeta.*(zeta+1)/8,      (2*xi-1).*eta.*(eta+1).*zeta.*(zeta+1)/8, ...
            (-2*xi).*eta.*(eta-1).*zeta.*(zeta-1)/4,       (2*xi-1).*(1-eta.^2).*zeta.*(zeta-1)/4,   ...
            (2*xi-1).*eta.*(eta-1).*(1-zeta.^2)/4,         (2*xi+1).*(1-eta.^2).*zeta.*(zeta-1)/4,   ...
            (2*xi+1).*eta.*(eta-1).*(1-zeta.^2)/4,         (-2*xi).*eta.*(eta+1).*zeta.*(zeta-1)/4,  ...
            (2*xi+1).*eta.*(eta+1).*(1-zeta.^2)/4,         (2*xi-1).*eta.*(eta+1).*(1-zeta.^2)/4,    ...
            (-2*xi).*eta.*(eta-1).*zeta.*(zeta+1)/4,       (2*xi-1).*(1-eta.^2).*zeta.*(zeta+1)/4,   ...
            (2*xi+1).*(1-eta.^2).*zeta.*(zeta+1)/4,        (-2*xi).*eta.*(eta+1).*zeta.*(zeta+1)/4,  ...
            (-2*xi).*(1-eta.^2).*zeta.*(zeta-1)/2,         (-2*xi).*eta.*(eta-1).*(1-zeta.^2)/2,     ...
            (2*xi-1).*(1-eta.^2).*(1-zeta.^2)/2,           (2*xi+1).*(1-eta.^2).*(1-zeta.^2)/2,      ...
            (-2*xi).*eta.*(eta+1).*(1-zeta.^2)/2,          (-2*xi).*(1-eta.^2).*zeta.*(zeta+1)/2,    ...
            (-2*xi).*(1-eta.^2).*(1-zeta.^2)];
        Neta = [xi.*(xi-1).*(2*eta-1).*zeta.*(zeta-1)/8,       xi.*(xi+1).*(2*eta-1).*zeta.*(zeta-1)/8, ...
            xi.*(xi+1).*(2*eta+1).*zeta.*(zeta-1)/8,       xi.*(xi-1).*(2*eta+1).*zeta.*(zeta-1)/8, ...
            xi.*(xi-1).*(2*eta-1).*zeta.*(zeta+1)/8,       xi.*(xi+1).*(2*eta-1).*zeta.*(zeta+1)/8, ...
            xi.*(xi+1).*(2*eta+1).*zeta.*(zeta+1)/8,       xi.*(xi-1).*(2*eta+1).*zeta.*(zeta+1)/8, ...
            (1-xi.^2).*(2*eta-1).*zeta.*(zeta-1)/4,        xi.*(xi-1).*(-2*eta).*zeta.*(zeta-1)/4,   ...
            xi.*(xi-1).*(2*eta-1).*(1-zeta.^2)/4,          xi.*(xi+1).*(-2*eta).*zeta.*(zeta-1)/4,   ...
            xi.*(xi+1).*(2*eta-1).*(1-zeta.^2)/4,          (1-xi.^2).*(2*eta+1).*zeta.*(zeta-1)/4,  ...
            xi.*(xi+1).*(2*eta+1).*(1-zeta.^2)/4,          xi.*(xi-1).*(2*eta+1).*(1-zeta.^2)/4,    ...
            (1-xi.^2).*(2*eta-1).*zeta.*(zeta+1)/4,        xi.*(xi-1).*(-2*eta).*zeta.*(zeta+1)/4,   ...
            xi.*(xi+1).*(-2*eta).*zeta.*(zeta+1)/4,        (1-xi.^2).*(2*eta+1).*zeta.*(zeta+1)/4,  ...
            (1-xi.^2).*(-2*eta).*zeta.*(zeta-1)/2,         (1-xi.^2).*(2*eta-1).*(1-zeta.^2)/2,     ...
            xi.*(xi-1).*(-2*eta).*(1-zeta.^2)/2,           xi.*(xi+1).*(-2*eta).*(1-zeta.^2)/2,      ...
            (1-xi.^2).*(2*eta+1).*(1-zeta.^2)/2,           (1-xi.^2).*(-2*eta).*zeta.*(zeta+1)/2,    ...
            (1-xi.^2).*(-2*eta).*(1-zeta.^2)];
        Nzeta= [xi.*(xi-1).*eta.*(eta-1).*(2*zeta-1)/8,        xi.*(xi+1).*eta.*(eta-1).*(2*zeta-1)/8, ...
            xi.*(xi+1).*eta.*(eta+1).*(2*zeta-1)/8,        xi.*(xi-1).*eta.*(eta+1).*(2*zeta-1)/8, ...
            xi.*(xi-1).*eta.*(eta-1).*(2*zeta+1)/8,        xi.*(xi+1).*eta.*(eta-1).*(2*zeta+1)/8, ...
            xi.*(xi+1).*eta.*(eta+1).*(2*zeta+1)/8,        xi.*(xi-1).*eta.*(eta+1).*(2*zeta+1)/8, ...
            (1-xi.^2).*eta.*(eta-1).*(2*zeta-1)/4,         xi.*(xi-1).*(1-eta.^2).*(2*zeta-1)/4,   ...
            xi.*(xi-1).*eta.*(eta-1).*(-2*zeta)/4,         xi.*(xi+1).*(1-eta.^2).*(2*zeta-1)/4,   ...
            xi.*(xi+1).*eta.*(eta-1).*(-2*zeta)/4,         (1-xi.^2).*eta.*(eta+1).*(2*zeta-1)/4,  ...
            xi.*(xi+1).*eta.*(eta+1).*(-2*zeta)/4,         xi.*(xi-1).*eta.*(eta+1).*(-2*zeta)/4,    ...
            (1-xi.^2).*eta.*(eta-1).*(2*zeta+1)/4,         xi.*(xi-1).*(1-eta.^2).*(2*zeta+1)/4,   ...
            xi.*(xi+1).*(1-eta.^2).*(2*zeta+1)/4,          (1-xi.^2).*eta.*(eta+1).*(2*zeta+1)/4,  ...
            (1-xi.^2).*(1-eta.^2).*(2*zeta-1)/2,           (1-xi.^2).*eta.*(eta-1).*(-2*zeta)/2,     ...
            xi.*(xi-1).*(1-eta.^2).*(-2*zeta)/2,           xi.*(xi+1).*(1-eta.^2).*(-2*zeta)/2,      ...
            (1-xi.^2).*eta.*(eta+1).*(-2*zeta)/2,          (1-xi.^2).*(1-eta.^2).*(2*zeta+1)/2,    ...
            (1-xi.^2).*(1-eta.^2).*(-2*zeta)];
    case {'Hexa27vtk'}
        N    = [xi.*(xi-1).*eta.*(eta-1).*zeta.*(zeta-1)/8,    xi.*(xi+1).*eta.*(eta-1).*zeta.*(zeta-1)/8, ...
            xi.*(xi+1).*eta.*(eta+1).*zeta.*(zeta-1)/8,    xi.*(xi-1).*eta.*(eta+1).*zeta.*(zeta-1)/8, ...
            xi.*(xi-1).*eta.*(eta-1).*zeta.*(zeta+1)/8,    xi.*(xi+1).*eta.*(eta-1).*zeta.*(zeta+1)/8, ...
            xi.*(xi+1).*eta.*(eta+1).*zeta.*(zeta+1)/8,    xi.*(xi-1).*eta.*(eta+1).*zeta.*(zeta+1)/8, ...
            (1-xi.^2).*eta.*(eta-1).*zeta.*(zeta-1)/4,     xi.*(xi+1).*(1-eta.^2).*zeta.*(zeta-1)/4,   ...
            (1-xi.^2).*eta.*(eta+1).*zeta.*(zeta-1)/4,     xi.*(xi-1).*(1-eta.^2).*zeta.*(zeta-1)/4,   ...
            (1-xi.^2).*eta.*(eta-1).*zeta.*(zeta+1)/4,     xi.*(xi+1).*(1-eta.^2).*zeta.*(zeta+1)/4,   ...
            (1-xi.^2).*eta.*(eta+1).*zeta.*(zeta+1)/4,     xi.*(xi-1).*(1-eta.^2).*zeta.*(zeta+1)/4,   ...
            xi.*(xi-1).*eta.*(eta-1).*(1-zeta.^2)/4,       xi.*(xi+1).*eta.*(eta-1).*(1-zeta.^2)/4,    ...
            xi.*(xi+1).*eta.*(eta+1).*(1-zeta.^2)/4,       xi.*(xi-1).*eta.*(eta+1).*(1-zeta.^2)/4,    ...
            xi.*(xi-1).*(1-eta.^2).*(1-zeta.^2)/2,         xi.*(xi+1).*(1-eta.^2).*(1-zeta.^2)/2,      ...
            (1-xi.^2).*eta.*(eta-1).*(1-zeta.^2)/2,       (1-xi.^2).*eta.*(eta+1).*(1-zeta.^2)/2,      ...
            (1-xi.^2).*(1-eta.^2).*zeta.*(zeta-1)/2,      (1-xi.^2).*(1-eta.^2).*zeta.*(zeta+1)/2,     ...
            (1-xi.^2).*(1-eta.^2).*(1-zeta.^2)];
        
    otherwise
        error ('Error in ShapeFunc, non suported type of element')
end