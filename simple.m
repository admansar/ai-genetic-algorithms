function geneticAlgorithm()
    POPULATION_SIZE = 20;
    CHROMOSOME_LENGTH = 10;
    MUTATION_RATE = 0.1;
    GENERATIONS = 50;

    population = randi([0, 1], POPULATION_SIZE, CHROMOSOME_LENGTH);
    bestSolution = [];
    bestFitness = 0;

    for generation = 1:GENERATIONS
        fitnessScores = sum(population, 2);

        [fitnessScores, indices] = sort(fitnessScores, 'descend');
        population = population(indices, :);

        if fitnessScores(1) > bestFitness
            bestSolution = population(1, :);
            bestFitness = fitnessScores(1);
        end

        fprintf('Generation %d: Best Fitness = %d\n', generation, bestFitness);

        nextGeneration = zeros(size(population));
        for i = 1:2:POPULATION_SIZE
            tournament = population(randperm(POPULATION_SIZE, 2), :);
            [~, tIdx] = sort(sum(tournament, 2), 'descend');
            parent1 = tournament(tIdx(1), :);
            parent2 = tournament(tIdx(2), :);

            crossoverPoint = randi([1, CHROMOSOME_LENGTH - 1]);
            child1 = [parent1(1:crossoverPoint), parent2(crossoverPoint+1:end)];
            child2 = [parent2(1:crossoverPoint), parent1(crossoverPoint+1:end)];

            child1 = mutate(child1, MUTATION_RATE);
            child2 = mutate(child2, MUTATION_RATE);

            nextGeneration(i, :) = child1;
            if i + 1 <= POPULATION_SIZE
                nextGeneration(i+1, :) = child2;
            end
        end
        population = nextGeneration;
    end
    fprintf('\nBest Solution Found: %s\n', num2str(bestSolution));
    fprintf('Best Fitness: %d\n', bestFitness);

    function individual = mutate(individual, mutationRate)
        for j = 1:CHROMOSOME_LENGTH
            if rand < mutationRate
                individual(j) = 1 - individual(j);
            end
        end
    end
end

geneticAlgorithm();



