class Grid {
  final int n, m;
  final List<List<int>> grid;

  Grid(this.n, this.m, this.grid);

  bool isValid(int x, int y) {
    return x >= 0 && x < n && y >= 0 && y < m && grid[x][y] == 0;
  }
}
