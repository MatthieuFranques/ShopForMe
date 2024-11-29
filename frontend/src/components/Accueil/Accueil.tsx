import React from "react";
import './accueil.scss'
import image1 from "../../images/imag1.png"
import image2 from "../../images/image2.png"
import image3 from "../../images/image3.png"
import apple from "../../images/telecharger-apple-app-store_francais.png"
import google from "../../images/en_badge_web_generic.png"


export default function Accueil() {

    return (
        <div className={"accueil_container"}>
            <h1>Vos courses, votre autonomie.</h1>
            <p>Découvrez notre application innovante conçue pour simplifier les courses des personnes malvoyantes en
                magasin. Grâce à des outils d'accessibilité avancés et une interface intuitive, elle guide les
                utilisateurs dans leurs achats, leur offrant autonomie et confort. Une solution technologique au service
                de l'inclusion et de l'indépendance au quotidien.</p>

            <div className={"images_app"}>
                <img src={image1} alt=""/>
                <img src={image2} alt=""/>
                <img src={image3} alt=""/>
            </div>

            <div className={"download_app"}>
                <img src={apple} alt=""/>
                <img src={google} alt=""/>
            </div>

            <h2>A props de nous</h2>
            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Accusamus amet corporis, exercitationem illo
                iste obcaecati quisquam quo repellat sed sunt suscipit tenetur ut, voluptas. Aliquam doloremque numquam
                ratione sapiente vero.</p>


        </div>
    )
}

