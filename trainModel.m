% trainModel.m
% train model for metric learning
% all model data are saved in ./data/model/

clear all;
close all;
tic;

setpath;
dataSetName = 'msramm';
featureName = 'gist';
scale = true;
imgClassNo = get_dataSetInfo(dataSetName,'imgClassNo');
imgClass = get_dataSetInfo(dataSetName, 'imgClass');
labels = get_dataSetInfo(dataSetName,'labels2');

cPath = pwd;
workPath = cd(mLMNNPath);

for i = 1:size(imgClass, 1)
    if scale
        loadName = sprintf('%s/data/train/%sscale%d.mat', cPath, featureName, i);
    else
        loadName = sprintf('%s/data/train/%s%d.mat', cPath, featureName, i);
    end
    status = exist(loadName, 'file');
    if status == 0 
        disp(['i=', num2str(i),' loadName=',loadName,' doesnot exist! skipped!']);
        continue;
    end

    % load training data
    load(loadName);
    L0 = pca(xTr);
    dim = 500;
    [L, ~] = lmnn2(xTr, yTr, 5, L0, 'maxiter', 1000,'quiet',1,'outdim',dim, 'mu',0.5,'validation',0,'earlystopping',25);
    if scale
        saveName = sprintf('%s/data/model/%sscale%d.mat', cPath, featureName, i);
    else
        saveName = sprintf('%s/data/model/%s%d.mat', cPath, featureName, i);
    end
    save(saveName, 'L');
    % change to current work path
    disp (['i=', num2str(i), ' left=', num2str(size(imgClass, 1) -i)]);
end
cd(workPath);

disp('finished train model.');
toc;