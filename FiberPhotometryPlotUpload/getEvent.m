 function [Event,EventName]=getEvent(filename,EventTitle)

 % EventTitle={'lick','footshock','laser','hypoxia','optogenetics','N2'};
 
varname=who('-file',filename);
load(filename);
for i= 1:length(varname)
    isevent=strcmpi(varname{i},EventTitle);
    if any(isevent)           
        eval(['Event=' varname{i} ';']);
        EventName=EventTitle{find(isevent)};        
    end
end