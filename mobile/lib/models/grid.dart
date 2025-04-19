class Grid {
  final int rows, cols;
  final List<List<int>> grid;
  final List<List<int>> beaconPositions;
  // TODO List<List<int>>
  final List<int> productPosition;

  Grid(this.rows, this.cols, this.grid, this.beaconPositions,
      this.productPosition);

  bool isValid(int posX, int posY) {
    return posX >= 0 && posX < rows && posY >= 0 && posY < cols;
  }

  int getValue(int row, int col) => grid[row][col];

  String toStringData() {
    String result = "";
    for (int i = 0; i < rows; i++) {
      String row = "row $i : ";
      for (int a = 0; a < cols; a++) {
        row = row + ", ${grid[i][a]}";
      }
      result = result + " $row ";
      print(row);
    }
    return result;
  }
}
