import React from 'react';
import {Link} from 'react-router-dom';
import './nav.scss';

const Navbar: React.FC = () => {
    return (
        <nav className="navbar">
            <Link to="/" className="navbar-link">Accueil</Link>
            <Link to="/login" className="navbar-link">Login</Link>
            <Link to="/shop" className="navbar-link">Shop</Link>
        </nav>
    )
}

export default Navbar;