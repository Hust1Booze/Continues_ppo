rng(0);

% get env
env = env();

% get net
ObservationInfo = getObservationInfo(env);
ActionInfo = getActionInfo(env);

% bug here? 等号右侧的输出数目不足，不满足赋值要求。
[critic,actor] = net(ObservationInfo,ActionInfo);


% set agent parameters
criticOptions = rlOptimizerOptions( ...
    LearnRate=1e-3, ...
    GradientThreshold=1);
actorOptions = rlOptimizerOptions( ...
    LearnRate=2e-4, ...
    GradientThreshold=1);

agentOpts = rlPPOAgentOptions(...
    SampleTime=-1,...
    ActorOptimizerOptions=actorOptions,...
    CriticOptimizerOptions=criticOptions,...
    ExperienceHorizon=200,...
    ClipFactor=0.2,... 
    EntropyLossWeight=0.01,...
    MiniBatchSize=64,...
    NumEpoch=3,...
    AdvantageEstimateMethod="gae",...
    GAEFactor=0.95,...
    DiscountFactor=0.998);


agent = rlPPOAgent(actor,critic,agentOpts);


% Test
%getAction(agent,{rand(ObservationInfo.Dimension)});

% train parameters
trainOpts = rlTrainingOptions(...
    MaxEpisodes=10000,...
    MaxStepsPerEpisode=1,...
    ScoreAveragingWindowLength=10,...
    Plots="training-progress",...
    StopTrainingCriteria="AverageReward",...
    StopTrainingValue=10000);

doTraining = true;

if doTraining
    trainingStats = train(agent,env,trainOpts);
    save('Agent.mat','agent');
else
    load('Agent.mat','agent');
end