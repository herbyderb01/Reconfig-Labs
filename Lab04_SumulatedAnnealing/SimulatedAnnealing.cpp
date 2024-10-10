#include <iostream>
#include <fstream>
#include <vector>
#include <cstdlib>
#include <cmath>
#include <ctime>
#include <algorithm>
#include <chrono>

struct Node {
    int id;
    int x;
    int y;
};

struct Edge {
    int start;
    int end;
};

void fix_placement();

std::vector<Node> nodes;
std::vector<Edge> edges;
int gridX, gridY, numNodes;

void parseInput(const std::string &filename) {
    std::ifstream infile(filename);
    std::string line;

    // Read grid size
    infile >> line >> gridX >> gridY;

    // Read number of nodes
    infile >> line >> numNodes;
    nodes.resize(numNodes);

    for (int i = 0; i < numNodes; ++i) {
        nodes[i].id = i;
        nodes[i].x = rand() % gridX; // Random initial placement on the grid
        nodes[i].y = rand() % gridY;
    }
	fix_placement();

    // Read edges
    while (infile >> line) {
        int start, end;
        infile >> start >> end;
        edges.push_back({start, end});
    }
}

double calculateEnergy() {
    double energy = 0.0;
    for (const auto &edge : edges) {
        int dx = std::abs(nodes[edge.start].x - nodes[edge.end].x);
        int dy = std::abs(nodes[edge.start].y - nodes[edge.end].y);
		dx *= dx;
		dy *= dy;
		if(dx == 0 && dy == 0)
			energy += 10000;
        energy += (dx + dy); // Manhattan distance
    } 
	for (int i = 0; i < numNodes; i++) {
		for(int j = 0; j < numNodes; j++){
			if(nodes[i].x == nodes[j].x	&& nodes[i].y == nodes[j].y && i != j)
				energy += 10000;
		}
    }
    return energy;
}

void determine_action(int* dx, int* dy){
	int action = rand()%4;
	switch (action){
		case 0:
			*dx = 0;
			*dy = 1;
			break;
		case 1:
			*dx = 0;
			*dy = -1;
			break;
		case 2:
			*dx = 1;
			*dy = 0;
			break;
		case 3:
			*dx = -1;
			*dy = 0;
			break;
	}
}

void fix_placement(){
	int dx;
	int dy;
	for (int i = 0; i < numNodes; i++) {
		for(int j = 0; j < numNodes; j++){
			while(nodes[i].x == nodes[j].x && nodes[i].y == nodes[j].y && i != j){
				determine_action(&dx, &dy);
				if(nodes[i].x + dx < gridX && nodes[i].x + dx >= 0 
				&& nodes[i].y + dy < gridY && nodes[i].y + dy >= 0){
					nodes[i].x += dx;
					nodes[i].y += dy;
				}
			}
				
		}
    }
}

bool valid_placement(int dx, int dy, int idx){
	for(int j = 0; j < numNodes; j++){
		if(nodes[idx].x + dx == nodes[j].x && nodes[idx].y + dy == nodes[j].y && idx != j){
			return false;
		}
	}
	return true;
}

void simulatedAnnealing(double initialTemp, double coolingRate) {
    double temperature = initialTemp;
	double currentEnergy = calculateEnergy();
	int dx;
	int dy;
    while (temperature > 0.1) {
        // Generate neighbor solution by swapping two nodes
        int idx1 = abs(rand() % numNodes);
		int idx2 = abs(rand() % numNodes);
		
		double currentEnergy = calculateEnergy();
		/*determine_action(&dx, &dy);
		//checks to make sure we make a valid movement checking grid
		//boundaries and making sure we don't place on top of another.
		while((nodes[idx1].x + dx > gridX || nodes[idx1].x + dx < 0) 
		|| (nodes[idx1].y + dy > gridY || nodes[idx1].y + dy < 0) 
		|| !valid_placement(dx,dy,idx1)){
			determine_action(&dx, &dy);
			idx1 = abs(rand() % numNodes);
		}

		nodes[idx1].x += dx;
		nodes[idx1].y += dy;
		int if_swap = rand() % 20;
		if(if_swap == 15){
			int tempx = nodes[idx1].x;
			int tempy = nodes[idx1].y;
			nodes[idx1].x = nodes[idx2].x;
			nodes[idx1].y = nodes[idx2].y;
			nodes[idx2].x = tempx;
			nodes[idx2].y = tempy;
		}*/
		int new_x = rand() % gridX; // Random initial placement on the grid
        int new_y = rand() % gridY;
		int old_x = nodes[idx1].x;
		int old_y = nodes[idx1].y;
		nodes[idx1].x = new_x;
		nodes[idx1].y = new_y;
        double newEnergy = calculateEnergy();
											// Store the current energy before swapping

        if (newEnergy < currentEnergy || 
            (std::exp((currentEnergy - newEnergy) / temperature) > (double)rand() / RAND_MAX)) {
            // Accept the new solution
        } else {
			nodes[idx1].x = old_x;
			nodes[idx1].y = old_y;	
            // Revert the swap if not accepted
			/*if(if_swap == 15){
				int tempx = nodes[idx1].x;
				int tempy = nodes[idx1].y;
				nodes[idx1].x = nodes[idx2].x;
				nodes[idx1].y = nodes[idx2].y;
				nodes[idx2].x = tempx;
				nodes[idx2].y = tempy;
			}
			nodes[idx1].x -= dx;
			nodes[idx1].y -= dy;
			*/
        }

        temperature *= coolingRate; // Cool down
    }
}

void outputResults(const std::string &filename) {
    std::ofstream outfile(filename);
    for (const auto &node : nodes) {
        outfile << "Node " << node.id << " placed at (" << node.x << ", " << node.y << ")\n";
		std::cout << "Node " << node.id << " placed at (" << node.x << ", " << node.y << ")\n";
    }

    for (const auto &edge : edges) {
        int length = std::abs(nodes[edge.start].x - nodes[edge.end].x) + 
                     std::abs(nodes[edge.start].y - nodes[edge.end].y);
        outfile << "Edge from " << edge.start << " to " << edge.end << " has length " << length << "\n";
		std::cout << "Edge from " << edge.start << " to " << edge.end << " has length " << length << "\n";
    }
	outfile << calculateEnergy();
	std::cout << calculateEnergy();
}

int main(int argc, char *argv[]) {
    srand(static_cast<unsigned int>(time(0))); // Seed for random number generation
	double cooling_temp = .99;
	int iterations = 10;
	double temp = 1000001.0;
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " input.txt output.txt\n";
        return 1;
    }

    parseInput(argv[1]);
	//outputResults(argv[2]);
    //simulatedAnnealing(1000000.0, 0.999); // Adjust parameters for your experiments
    //outputResults(argv[2]);
	std::ofstream outFile("simulated_annealing_init_temp_results_3.csv");
	outFile << "CoolingRate, Energy, Time(s)\n";
	double duration_s;
	double energy_s;
	for(int i = 0; i < 100; i++){
		energy_s = 0;
		duration_s = 0;
		for(int j = 0; j < iterations; j++){
			auto start = std::chrono::high_resolution_clock::now();
			simulatedAnnealing(temp, cooling_temp);
			auto end = std::chrono::high_resolution_clock::now();
			auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
			duration_s += duration;
			energy_s += calculateEnergy();
		}
		outFile << temp << "," << energy_s/iterations << "," << duration_s/iterations << "\n";
		//cooling_temp -= .009
		temp -= 10000;
	}
	outFile.close();

    return 0;
}
