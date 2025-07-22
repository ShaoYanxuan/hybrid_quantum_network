function tags_cut = cut_timetags(TAGS_HOM_RAW, ncut, ti)
L = length(TAGS_HOM_RAW(:,1));
N = fix(L/ncut);
tags_cut(:,:) = TAGS_HOM_RAW(N*(ti-1)+1:N*ti,:);
