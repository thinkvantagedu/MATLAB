function [textfile]=RemoveOneStringRowinText(textfile_origin, str_rmv)

str_length=length(str_rmv);

for i_rmv=1:length(textfile_origin)
   if strncmpi(textfile_origin(i_rmv,:), str_rmv, str_length)==1
      %identify line location of required text.
      line_node_rmv=i_rmv;
      break
   end
end
textfile_origin(line_node_rmv, :)=[];
textfile=textfile_origin;