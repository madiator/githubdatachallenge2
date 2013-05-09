% Import the appropriate file: either AllEvents.csv or PushEvents.csv
% After importing, the languages must be in textdata and the values
% (days, counts) in data.
% textdata should probably start with 'repository_language'

c = containers.Map;
mapIndexToLanguage = containers.Map;
numLanguages = 0;
for i = 2:length(textdata)
    language = char(textdata(i));
    if(isKey(c,language)==0)
        numLanguages = numLanguages + 1;
        c(language) = numLanguages;
        mapIndexToLanguage(char(numLanguages)) = language;
    end
end
%%
minday = min(data(:,1));
data(:,1) = data(:,1) - minday + 1; % so the days start from 1.

numDays = max(data(:,1));
% In my case (i.e. with the given dataset), the first date is 15410, which
% corresponds to 15410*24*3600 = 1331424000 seconds after epoch, and that
% is 11 Mar 2012, a sunday. So adjust accordingly:
weekends = [1:7:424 7:7:424];
weekends = sort(weekends);

values = zeros(numDays, numLanguages);
for i = 1:size(data,1)
    values(data(i,1),c(char(textdata(i+1)))) = data(i,2);
end

%%



languageRatio = zeros(numLanguages, 1);
for i = 1:numLanguages
    vals = values(:,i);
    if(size(find(vals)) < numDays)
        languageRatio(i) = 0;
    else
        languageRatio(i) = sum(vals(weekends, 1))/sum(vals(:,1));
    end
end

%%
[sortedvals sortkey] = sort(languageRatio,'descend');
totalGoodRatios = length(find(sortedvals>0)); 
languageLabels = [];
for i = 1:totalGoodRatios
    language = mapIndexToLanguage(char(sortkey(i)));
    %languageLabels = [languageLabels;language];
    display(strcat(language,',',num2str(100*sortedvals(i))));
    %display(strcat(language));
    %display(num2str(sortedvals(i)*100));
end