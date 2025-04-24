import React from 'react';
import {Link} from 'react-router-dom';
import './nav.scss';
import shop from "../../images/cart-large-minimalistic-svgrepo-com.svg"
import log from "../../images/login-svgrepo-com.svg"
import home from "../../images/home-smile-svgrepo-com.svg"
import demo from "../../images/demo.svg"

const Navbar: React.FC = () => {
    return (
        <nav className="navbar">
            <h1>Menu</h1>
            <div>
                <Link to="/" className="navbar-link">
                    <img src={home} alt="icon Accueil"/>
                    Accueil
                </Link>
                <Link to="/login" className="navbar-link">
                    <img src={log} alt="icon Login"/>
                    Login
                </Link>
                <Link to="/shop" className="navbar-link">
                    <img src={shop} alt="icon Shop"/>
                    Shop
                </Link>
                <Link to="/demo" className="navbar-link">
                    <img src={demo} alt="icon Demo"/>
                    Demo
                </Link>
            </div>
        </nav>
    )
}

export default Navbar;