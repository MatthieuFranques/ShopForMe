import React from 'react';
import './App.css';
import {BrowserRouter, Route, Routes} from "react-router-dom";
import Accueil from "./components/Accueil/Accueil";
import Login from "./components/Login/Login";
import NavBar from "./components/NavBar/NavBar";
import Shop from "./components/Shop/Shop";
import SingleShop from "./components/Shop/SingleShop";
import Demo from "./components/Demo/Demo";

function App() {
    return (
        <div className={"app-container"}>
            <BrowserRouter>
                <NavBar />
                <Routes>
                    <Route path="/login" element={<Login />} />
                    <Route path="/" element={<Accueil />} />
                    <Route path="/shop" element={<Shop />} />
                    <Route path="/demo" element={<Demo />} />
                    <Route path="/shop/:id" element={<SingleShop />} />
                </Routes>
            </BrowserRouter>
        </div>
    );
}

export default App;
