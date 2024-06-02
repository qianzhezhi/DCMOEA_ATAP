function con = getcon(Problem,constrain)
%GETCON 此处显示有关此函数的摘要
    switch Problem.Name
        case  'DCF1'
            con=max(constrain,0);
        case 'DCF2'
            con=max(constrain,0);
        case  'DCF3'
            con=max(constrain,0);
        case  'DCF4'
            con=max(constrain,0);
        case 'DCF5'
            con=max(constrain(1,1),0)+max(constrain(1,2),0);
        case 'DCF6'
            con=max(constrain,0);
        case 'DCF7'
            con=max(constrain,0);
        case 'DCF8'
            con=max(constrain(1,1),0)+max(constrain(1,2),0);
        case 'DCF9'
            con=max(constrain(1,1),0)+max(constrain(1,2),0);
        case  'DCF10'
            con=max(constrain,0);

    end
end

