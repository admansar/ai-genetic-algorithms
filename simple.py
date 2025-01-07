import random

POPULATION_SIZE = 20  # number of individuals in the population
CHROMOSOME_LENGTH = 10  # length of the bit array
MUTATION_RATE = 0.1  # probability of mutation
GENERATIONS = 50  # number of generations


def fitness(chromosome) -> int:
    return sum(chromosome)


def create_individual() -> list[int]:
    """
    create a random list of 0 and 1
    """
    return [random.randint(0, 1) for _ in range(CHROMOSOME_LENGTH)]


def create_population() -> list[list[int]]:
    """
    create a list for the population
    """
    return [create_individual() for _ in range(POPULATION_SIZE)]


def select_parents(population) -> list:
    tournament_size = 3
    selected: list = []
    for _ in range(2):  # Select two parents
        tournament = random.sample(population, tournament_size)
        selected.append(max(tournament, key=fitness))  # Pick the fittest individual
    return selected


def crossover(parent1, parent2) -> tuple:
    """
    making crossover between parents, creating a new childs from the crossover
    between the parents, the goal is to create a new generation
    """
    crossover_point: int = random.randint(1, CHROMOSOME_LENGTH - 1)
    child1 = parent1[:crossover_point] + parent2[crossover_point:]
    child2 = parent2[:crossover_point] + parent1[crossover_point:]
    return (child1, child2)


def mutate(individual) -> list:
    for i in range(CHROMOSOME_LENGTH):
        if random.random() < MUTATION_RATE:
            individual[i] = 1 - individual[i]  # Flip the bit
    return individual


def genetic_algorithm() -> None:
    population: list[list[int]] = create_population()
    best_solution: list[int] = None
    best_fitness = 0

    for generation in range(GENERATIONS):
        population = sorted(population, key=fitness, reverse=True)
        if fitness(population[0]) > best_fitness:
            best_solution = population[0]
        # Create the next generation
            best_fitness = fitness(population[0])

        print(f"Generation {generation}: Best Fitness = {best_fitness}")

        next_generation = []
        while len(next_generation) < POPULATION_SIZE:
            parent1, parent2 = select_parents(population)
            child1, child2 = crossover(parent1, parent2)
            next_generation.append(mutate(child1))
            if len(next_generation) < POPULATION_SIZE:
                next_generation.append(mutate(child2))

        population = next_generation

    print("\nbest solution:", best_solution)
    print("best fitness:", best_fitness)


if __name__ == "__main__":
    genetic_algorithm()
