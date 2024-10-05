function ecg = importECG(x)
    opts = delimitedTextImportOptions("NumVariables", 3);
    
    % Specify range and delimiter
    opts.DataLines = [1, Inf];
    opts.Delimiter = "\t";
    
    % Specify column names and types
    opts.VariableNames = ["VarName1", "VarName2", "Var3"];
    opts.SelectedVariableNames = ["VarName1", "VarName2"];
    opts.VariableTypes = ["double", "double", "string"];
    
    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    
    % Specify variable properties
    opts = setvaropts(opts, "Var3", "WhitespaceRule", "preserve");
    opts = setvaropts(opts, "Var3", "EmptyFieldRule", "auto");
    
    % Import the data
    ecg = readtable(x, opts);

    %Convert to output type
    ecg = table2array(ecg);
    % Clear temporary variables
    clear opts
end
