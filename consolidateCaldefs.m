% consolidate the calibratable parameters and save the same to a mat file
clear all
run('C:\Palani\Simulink\App\start_taxibot_app.m');
ws_vars = whos;
cal_vars = [];
cal_vars = {'Calibratable Signal Name', 'Signal Description', 'Current Data Value', 'Signal Units', 'Signal DataType', 'Signal Min Value', 'Signal Max Value'};
for i=1:length(ws_vars)
    try
        var_obj = eval(ws_vars(i).name);
        fileN = var_obj.RTWInfo.CustomAttributes.DefinitionFile;
        if ~isempty(strfind(fileN, '_cal_'))
            if isnum(
            cal_vars(end+1,:)={ws_vars(i).name, var_obj.Description, var_obj.Value, var_obj.DocUnits, var_obj.DataType, var_obj.Min, var_obj.Max};
        end
    catch
        continue
    end
end
xlswrite('WS_cal_data.xls',cal_vars);