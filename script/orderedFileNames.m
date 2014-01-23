d = dir('*.jpg');

for i=1:length(d)
   thisName = ['object' prepend(i,4) '.jpg'];
   unix(['mv ' d(i).name ' ' thisName]);    
end