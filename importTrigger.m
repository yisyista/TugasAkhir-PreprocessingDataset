function trig = importTrigger(x)
    opts = delimitedTextImportOptions("NumVariables", 3);
    
    % Specify range and delimiter
    opts.DataLines = [1, Inf];
    opts.Delimiter = "\t";
    
    % Specify column names and types
    opts.VariableNames = ["Var1", "VarName2", "VarName3"];
    opts.SelectedVariableNames = ["VarName2", "VarName3"];
    opts.VariableTypes = ["string", "double", "double"];
    
    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    
    % Specify variable properties
    opts = setvaropts(opts, "Var1", "WhitespaceRule", "preserve");
    opts = setvaropts(opts, "Var1", "EmptyFieldRule", "auto");
    
    % Import the data
    trig = readtable(x, opts);
    
    %Convert to output type
    trig = table2array(trig);

    % Clear temporary variables
    clear opts
end