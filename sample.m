msgBoxObj = msgbox('Model compiling and building in Progress...');
assignin('base', 'msgBox', msgBoxObj);
msgEvel = evalin('base','msgBox');
delete(msgEvel);

msgbox(msgBoxObj);