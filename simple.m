POPULATION_SIZE = 20;
CHROMOSOME_LENGTH = 10;
MUTATION_RATE = 0.1;
GENERATIONS = 50;

function fit = fitness(chromosome)
    fit = sum(chromosome);
end
function individual = createIndividual(chromosomeLength)
    individual = randi([0, 1], 1, chromosomeLength);
end
function population = createPopulation(populationSize, chromosomeLength)
    population = zeros(populationSize, chromosomeLength);
    for i = 1:populationSize
        population(i, :) = createIndividual(chromosomeLength);
    end
end
function parents = selectParents(population)
    numIndividuals = size(population, 1);
    parents = zeros(2, size(population, 2));
    
    for i = 1:2
        tournament = population(randperm(numIndividuals, 2), :);
        scores = sum(tournament, 2);
        [~, idx] = max(scores);
        parents(i, :) = tournament(idx, :);
    end
end
function [child1, child2] = crossover(parent1, parent2)
    crossoverPoint = randi([1, length(parent1) - 1]);
    child1 = [parent1(1:crossoverPoint), parent2(crossoverPoint+1:end)];
    child2 = [parent2(1:crossoverPoint), parent1(crossoverPoint+1:end)];
end
function mutated = mutate(individual, mutationRate)
    mutated = individual;
    for i = 1:length(individual)
        if rand < mutationRate
            mutated(i) = 1 - mutated(i);
        end
    end
end
function geneticAlgorithm()
    global POPULATION_SIZE CHROMOSOME_LENGTH MUTATION_RATE GENERATIONS
    population = createPopulation(POPULATION_SIZE, CHROMOSOME_LENGTH);
    bestSolution = [];
    bestFitness = 0;
    for generation = 1:GENERATIONS
        fitnessScores = sum(population, 2);
        [~, indices] = sort(fitnessScores, 'descend');
        population = population(indices, :);
        if fitnessScores(1) > bestFitness
            bestSolution = population(1, :);
            bestFitness = fitnessScores(1);
        end
        fprintf('Generation %d: Best Fitness = %d\n', generation, bestFitness);
        nextGeneration = zeros(size(population));
        for i = 1:2:POPULATION_SIZE
            parents = selectParents(population);
            [child1, child2] = crossover(parents(1, :), parents(2, :));
            nextGeneration(i, :) = mutate(child1, MUTATION_RATE);
            if i+1 <= POPULATION_SIZE
                nextGeneration(i+1, :) = mutate(child2, MUTATION_RATE);
            end
        end
        population = nextGeneration;
    end
    
    fprintf('\nBest Solution Found: %s\n', num2str(bestSolution));
    fprintf('Best Fitness: %d\n', bestFitness);
end

geneticAlgorithm();

