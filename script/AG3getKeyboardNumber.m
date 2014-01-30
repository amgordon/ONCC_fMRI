
function k = AG3getKeyboardNumber
% Gets laptop internal keyboard for Ben's laptop, INERTIA

d=PsychHID('Devices');
k = 0;

for n = 1:length(d)
    if (strcmp(d(n).usageName,'Keyboard') && strcmp(d(n).manufacturer,'Apple Inc.'));  %560 for Recca % 538 for laptop kb, 544 for alan external, 516 for rm 410
        k=n;
        break
    end
end
