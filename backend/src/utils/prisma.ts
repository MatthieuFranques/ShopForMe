import { PrismaClient } from "@prisma/client";

/**
 * Initializes a prisma client instance to interact with the database
 */
const prisma = new PrismaClient();

export default prisma;