import React, {useState} from "react";

export default function Login() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");

    const handleEmailChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setEmail(e.target.value);
    };

    const handlePasswordChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setPassword(e.target.value);
    };

    const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        console.log("Email:", email);
        console.log("Password:", password);
    };

    return (
        <div className="container_accueil" style={{
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            justifyContent: "center",
            minHeight: "100vh",
            backgroundColor: "#f5f5f5",
            padding: "20px"
        }}>
            <form onSubmit={handleSubmit} style={{
                backgroundColor: "#fff",
                padding: "50px",
                borderRadius: "8px",
                boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
                maxWidth: "400px",
                width: "100%"
            }}>
                <div style={{marginBottom: "15px"}}>
                    <label htmlFor="email"
                           style={{display: "block", marginBottom: "5px", fontWeight: "bold"}}>Email:</label>
                    <input
                        type="email"
                        id="email"
                        value={email}
                        onChange={handleEmailChange}
                        style={{width: "100%", padding: "10px", borderRadius: "4px", border: "1px solid #ccc"}}
                    />
                </div>
                <div style={{marginBottom: "15px"}}>
                    <label htmlFor="password"
                           style={{display: "block", marginBottom: "5px", fontWeight: "bold"}}>Password:</label>
                    <input
                        type="password"
                        id="password"
                        value={password}
                        onChange={handlePasswordChange}
                        style={{width: "100%", padding: "10px", borderRadius: "4px", border: "1px solid #ccc"}}
                    />
                </div>
                <button type="submit" style={{
                    width: "100%",
                    padding: "10px",
                    borderRadius: "4px",
                    backgroundColor: "#4CAF50",
                    color: "#fff",
                    fontWeight: "bold",
                    border: "none",
                    cursor: "pointer",
                }}>Login
                </button>
            </form>
        </div>
    )
}