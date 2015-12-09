import std.array,
       std.conv,
       std.stdio,
       std.algorithm;

struct edge {
    bool visited;
    int distance;
}

void graph_insert(ref edge[string][string] graph, string line) {
    auto parts = line.split();
    auto distance = parse!int(parts[4]);
    edge e = { distance: distance, visited: false };
    graph[parts[0]][parts[2]] = e;
    graph[parts[2]][parts[0]] = e;
}

int shortest_route(edge [string][string] graph) {
    foreach (city; graph.byKey()) {
        writeln("At: ", city, " Next: ", graph[city]);
        recur(graph, city);
    }
    return 0;
}

int recur(edge[string][string] graph, string current) {
    if (graph[current].keys.count!(a => a.visited) == graph[current].length) {
        return 0;
    }

    foreach (city; graph.byKey()) {
        graph[city]
            .filter(a => !a.visited)
            .map(nextCity => graph[city][nextCity] + recur(graph, nextCity))
            .min();
    }

}

void main(string[] args)
{
    edge[string][string] graph;
    stdin
        .byLineCopy()
        .each!(l => graph_insert(graph, l));

    writeln("Graph: ", graph);
    shortest_route(graph);
}
