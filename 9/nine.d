import std.array,
       std.conv,
       std.stdio,
       std.range,
       std.algorithm;


void graph_insert(ref int[string][string] graph, ref bool[string] visits, string line) {
    auto parts = line.split();
    auto distance = parse!int(parts[4]);
    graph[parts[0]][parts[2]] = distance;
    graph[parts[2]][parts[0]] = distance;
    visits[parts[0]] = false;
    visits[parts[2]] = false;
}

int shortest_distance(int[string][string] graph, bool[string] visits, string current) {
    visits[current] = true;
    if (visits.byValue.all!()) {
        return 0;
    }
    return visits.byKeyValue
        .filter!(a => !a.value)
        .map!(a => graph[current][a.key] + shortest_distance(graph, visits.dup, a.key))
        .reduce!((a, b) => a < b ? a : b);
}

int longest_distance(int[string][string] graph, bool[string] visits, string current) {
    visits[current] = true;
    if (visits.byValue.all!()) {
        return 0;
    }
    return visits.byKeyValue
        .filter!(a => !a.value)
        .map!(a => graph[current][a.key] + longest_distance(graph, visits.dup, a.key))
        .reduce!((a, b) => a > b ? a : b);
}

void main(string[] args)
{
    int[string][string] graph;
    bool[string] visits;
    stdin
        .byLineCopy()
        .each!(l => graph_insert(graph, visits, l));

    auto ans1 = visits.byKey
        .map!(city => shortest_distance(graph, visits.dup, city))
        .reduce!((a, b) => a < b ? a : b);

    auto ans2 = visits.byKey
        .map!(city => longest_distance(graph, visits.dup, city))
        .reduce!((a, b) => a > b ? a : b);
    writeln("Shortest path: ", ans1);
    writeln("Longest path:  ", ans2);
}
