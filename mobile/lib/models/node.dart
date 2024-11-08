class Node implements Comparable<Node> {
  final int x, y;
  final int distance;

  Node(this.x, this.y, this.distance);

  @override
  int compareTo(Node other) {
    return distance.compareTo(other.distance);
  }
}
