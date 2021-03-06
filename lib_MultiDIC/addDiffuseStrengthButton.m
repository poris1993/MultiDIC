function []=addDiffuseStrengthButton(varargin)
%% Viewing figures: setting diffuse strength
% addDiffuseStrengthButton
% addDiffuseStrengthButton(hf)

% This script creates a new pushtool in a figure's toolbar to manipulate
% the ambient strength of a given patch of light on a displayed axis
%%
switch nargin
    case 0
        hf=gcf;
    case 1
        hf=varargin{1};
end

% Get icon
filePath=mfilename('fullpath');
toolboxPath=fileparts(fileparts(filePath));
iconPath=fullfile(toolboxPath,'lib_ext','GIBBON','icons');

hb = findall(hf,'Type','uitoolbar');
D=imread(fullfile(iconPath,'diffuse.jpg'));
S=double(D);
S=S-min(S(:));
S=S./max(S(:));
if size(S,3)==1
    S=repmat(S,[1 1 3]);
end

% Create a uipushtool in the toolbar
uipushtool(hb(1),'TooltipString','diffuse strength','CData',S,'Tag','diffuseStrength_button','ClickedCallback',{@DiffuseStrengthFunc,{hf}});
end

%% Ambient strength function  ambientStrengthFunc

function DiffuseStrengthFunc(~,~,inputCell)

hf = inputCell{1};
prompt = {'Input a value [0,1]:'};
dlg_title = 'Set diffuse strength';

hpatches = findobj(hf,'type','patch');
if ~isempty(hpatches)
    numPatches = size(hpatches,1);
    for i = 1:numPatches
        default = hpatches(i).DiffuseStrength;
        defaultOption = {num2str(default)};
    end
    s = 40 + max([cellfun(@numel,prompt) cellfun(@numel,defaultOption)]);

    Q = inputdlg(prompt,dlg_title,[1 s],defaultOption);
    if ~isempty(Q)
        for ii = 1:numPatches
            hpatches(ii).DiffuseStrength = str2double(Q{1});
        end
    end
else
    msgbox('There are no light patches in the figure');
end
end

%% 
% MultiDIC: a MATLAB Toolbox for Multi-View 3D Digital Image Correlation
% 
% License: <https://github.com/MultiDIC/MultiDIC/blob/master/LICENSE.txt>
% 
% Copyright (C) 2018  Dana Solav
% 
% If you use the toolbox/function for your research, please cite our paper:
% <https://engrxiv.org/fv47e>