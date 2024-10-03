from scipy.optimize import fsolve
import numpy as np

# Coordonnées des tags
tag1 = (x1, y1)
tag2 = (x2, y2)
tag3 = (x3, y3)

# Distances mesurées
d1 = distance1
d2 = distance2
d3 = distance3

# Fonction pour résoudre le système d'équations
def equations(variables):
    x, y = variables
    eq1 = np.sqrt((x - x1)**2 + (y - y1)**2) - d1
    eq2 = np.sqrt((x - x2)**2 + (y - y2)**2) - d2
    eq3 = np.sqrt((x - x3)**2 + (y - y3)**2) - d3
    return [eq1, eq2, eq3]

# Estimation initiale de la position de l'ancre
initial_guess = (0, 0)

# Résoudre le système
solution = fsolve(equations, initial_guess)
x_anchor, y_anchor = solution

print(f"La position de l'ancre est : ({x_anchor}, {y_anchor})")