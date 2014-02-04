d = dir('object*.jpg');

for i=1:length(d)
   thisName = ['scene' prepend(i,4) '.jpg'];
   unix(['mv ' d(i).name ' ' thisName]);    
end