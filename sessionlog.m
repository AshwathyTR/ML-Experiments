clear

% Adding paths
genius_dir = '';

log_dir = [genius_dir ''];
log_name = 'log';

profiles_dir = {
    '';
    };

addpath(log_dir);
for i = 1:size(profiles_dir, 1)
    addpath([genius_dir profiles_dir{i}]);
end

%% Reading the log

table = readtable( [log_name '.csv'], 'Delimiter', '(', 'ReadVariableNames', false);

stats = regexp(table{1:end-1,1}, ',', 'split');

stats1 = cell(size(stats, 1), 5);
for i= 1:size(stats, 1)
    stats1(i,:) = stats{i};
end

agent_names = stats1(1:3,4)
n_rounds = size(stats1, 1)

%% Times analysis
times = str2double( stats1(:,3) );
diff_times = times - [0; times(1:end-1)];

agent_times_agg = {times(1:3:end,:), times(2:3:end,:), times(3:3:end,:)};
agent_dtimes = {diff_times(1:3:end,:), diff_times(2:3:end,:), diff_times(3:3:end,:)};

figure(1), clf,
for i= 1:3
    subplot(2,3,i),   histogram(agent_dtimes{i}, 20), set(gca,'YScale','log'),
    xlabel('Time per round'), title( agent_names{i} )
    subplot(2,3,i+3), semilogy(agent_times_agg{i}, agent_dtimes{i})
    xlabel('Negotiation time'), ylabel('Time per round'),
end

agent_dtimes_agg = agent_times_agg{1} - [0; agent_times_agg{1}(1:end-1)] ;

figure(2), clf,
subplot(1,2,1), histogram(agent_dtimes_agg, 20), set(gca,'YScale','log')
title('Agreggated time'), xlabel('Time per round')
subplot(1,2,2), semilogy(agent_times_agg{1}, agent_dtimes_agg)
title('Agreggated time'), xlabel('Negotiation time'), ylabel('Time per round'),

%% Utility analysis

% Get profile names and directory
tree = xmlread( [log_name '.xml']);
agents_tree = tree.getElementsByTagName('resultsOfAgent');

profile_nums = zeros(3, 1);
for i=1:3
    agent_att = agents_tree.item(i-1).getAttributes(); % DOM indexes start at zero
    utilspace = char(agent_att.getNamedItem('utilspace').getTextContent());
    utilspace = regexp(utilspace, '(.+)\/(.+xml)$', 'tokens');
    
    profiles_dir = utilspace{1}{1};
    profile_name_split = regexp(utilspace{1}{2}, '^(\D+)(\d+).xml$', 'tokens');
    
    profile_name = profile_name_split{1}{1};
    profile_nums(i) = str2num(profile_name_split{1}{2});
end

% Build utility space
[ux, un, bs, hyper_utilities, nash, eval_names] = analyzeDomain([genius_dir profiles_dir], profile_name, profile_nums);
n_items = size(hyper_utilities);
n_issues = size( n_items, 2 ) - 1;

% Read bids
pattern = '^(\w+)\s+bid:Bid\[';
for j= 1:n_issues
    pattern = [pattern '.+:\s(.+),'];
end
pattern = [pattern '.+$'];

bids_raw = regexp(table{:,2}, pattern, 'tokens'); 

bids_raw1 = cell(n_rounds, 1+n_issues);
for l= 1:n_rounds
    bids_raw1(l,:) = bids_raw{l}{1};
end

actions = bids_raw1(:,1);
values = bids_raw1(:, 2:end);

for l = 1:n_rounds
    for j= 1:n_issues
        values{l,j} = find(strcmp(eval_names{j}, values{l,j}) == 1);
    end
end

utilities = zeros(n_rounds, 3);
for i = 1:3
    values_amp = [  num2cell( i*ones(n_rounds,1) ),  values ];
    for l = 1:n_rounds
        index = sub2ind(size(hyper_utilities), values_amp{l,:});
        utilities(l, i) = hyper_utilities(index);
    end
end
utilities3 = {utilities(1:3:end,:), utilities(2:3:end,:), utilities(3:3:end,:)};

agreement = utilities3{1}(end,:);
agreement = [agreement, norm(agreement-nash)]

%% Plot bids and concession curves

hold on,
plot3(utilities3{1}(:,1), utilities3{1}(:,2), utilities3{1}(:,3), 'm'),
plot3(utilities3{2}(:,1), utilities3{2}(:,2), utilities3{2}(:,3), 'g'),
plot3(utilities3{3}(:,1), utilities3{3}(:,2), utilities3{3}(:,3), 'b'),
plot3(agreement(1), agreement(2), agreement(3), 'xk'),
xlabel(['First agent: ' agent_names{1}]),
ylabel(['Second agent: ' agent_names{2}]),
zlabel(['Third agent: ' agent_names{3}]),
legend('bids', 'minimum_utility', 'nash point', 'max_triangle', agent_names{:}, 'Negotiation point')

figure(4), clf,
plot(agent_times_agg{1}, utilities3{1}(:,1), 'm'), hold on,
plot(agent_times_agg{2}, utilities3{2}(:,2), 'g'), grid on,
plot(agent_times_agg{3}, utilities3{3}(:,3), 'b'),
title('Concession curves'), legend(agent_names{:}, 'Location', 'southwest'),
