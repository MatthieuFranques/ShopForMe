class Grid {
  final int rows, cols;
  final List<List<int>> grid;
  final List<List<int>> beaconPositions;
  // TODO List<List<int>>
  final List<int> productPosition; 

  Grid(this.rows, this.cols, this.grid, this.beaconPositions, this.productPosition);

  bool isValid(int posX, int posY) {
    return posX >= 0 && posX < rows && posY >= 0 && posY < cols && grid[posX][posY] == 0;
  }


}
