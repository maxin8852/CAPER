
N = length(NODE);       % Number of Nodes
S = length(SECTION);    % Number of Sections
D = length(DER);        % Number of DER
LD = length(LOAD);       % Number of Loads
LP = length(PARAM.Loop); % Number of Loops

% Let x = [a;alpha;b;bbar;beta1;beta2;c], then
% a     = x[    D*N    ]
% alpha = x[  D*(L+D)  ]
% b     = x[    D*S    ]
% bbar  = x[     S     ]
% beta1 = x[    D*S    ]
% beta2 = x[    D*S    ]
% c     = x[    D*LP   ]
% d     = x[     D     ]


% Define starting indicies
a       = 0;
alpha   = a+D*N;
b       = alpha+D*(LD+D);
bbar    = b+D*S;
beta1   = bbar+S;
beta2   = beta1+D*S;
c       = beta2+D*S;
d       = c+D*LP;


for i = 1:N
    for j = 1:D
        x{a+i+(j-1)*N} = sprintf('a_%s_MG%d',NODE(i).ID,j);
    end
end

for i = 1:S
    x{bbar+i} = sprintf('bbar_%s_%s',SECTION(i).FROM,SECTION(i).TO);
    for j = 1:D
        x{b+i+(j-1)*S} = sprintf('b_%s_%s_MG%d',SECTION(i).FROM,SECTION(i).TO,j);
        x{beta1+i+(j-1)*S} = sprintf('beta1_%s_%s_MG%d',SECTION(i).FROM,SECTION(i).TO,j);
        x{beta2+i+(j-1)*S} = sprintf('beta2_%s_%s_MG%d',SECTION(i).FROM,SECTION(i).TO,j);
    end
end

for i = 1:LD
    for j = 1:D
        x{alpha+i+(j-1)*(LD+D)} = sprintf('alpha_%s_MG%d',LOAD(i).ID,j);
    end
end

for i = 1:LP
    for j = 1:D
        x{c+i+(j-1)*LP} = sprintf('LOOP%d_MG%d',i,j);
    end
end

for i = 1:D
    x{d+i} = sprintf('c_MG%d',i);
    for j = 1:D
        x{alpha+LD+i+(j-1)*(LD+D)} = sprintf('alpha_%s_MG%d',DER(i).ID,j);
    end
end

save('xvars.mat','x')
%{
load('xvars.mat');
clear var
[n,~] = size(A);
for i = 1:n
    var(i) = {x(logical(A(i,:)))};
end
%}