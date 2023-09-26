function [filename, pathname]=getlastfile(filetype,ActionName,MultiSelect)
% open a or multi file from the last path
% filetype, the type of the file you want to open, like '*.mat';
% ActionName, prompt message
% MultiSelect, 0 means single, 1 mean multi
if nargin<1
    filetype='*.mat';
end
if nargin<2;
    MultiSelect=0;
    ActionName='Seclet the file';
end
if nargin<3;    
    MultiSelect=0;
end
global newpath;
oldpath=cd;
if isempty(newpath) || ~exist('newpath')
    newpath=cd;
end
try
    cd(newpath);
catch
end
if MultiSelect
    [filename, pathname] = uigetfile(filetype,ActionName,'MultiSelect','on');
    if pathname~=0
        newpath=pathname;
    end
else
    [filename, pathname] = uigetfile(filetype,ActionName);
    if filename~=0
        newpath=pathname;
    end
end
cd(oldpath);