import React from "react";
import './accueil.scss'

import bg from "../../images/bg.mp4"

export default function Accueil() {

    return (
        <div className="video-container">
            <video autoPlay loop muted playsInline className="background-video">
                <source src={bg} type="video/mp4"/>
                Votre navigateur ne supporte pas la balise vidéo.
            </video>
            <div className="content">
                <h1>L'application qui vous aide à faire vos courses</h1>
                <a href={"#start"}>Explorer</a>
            </div>

            <h2 id={"start"}>Lorem ipsum</h2>
            <div>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Dignissimos ex, excepturi fugit impedit
                magnam maiores nisi nostrum perferendis recusandae suscipit. Ex id incidunt inventore nesciunt obcaecati
                praesentium quas quisquam soluta.
            </div>
            <div>Aut consectetur, cupiditate debitis deleniti dolores eligendi facilis fugiat illo illum labore nam,
                nisi nulla perspiciatis repellendus saepe tempora ut, voluptas? Aliquam cumque debitis ipsam minima quia
                repudiandae ullam unde.
            </div>
            <div>Adipisci assumenda dolores eum explicabo illo modi odit perferendis, repudiandae tempora totam. A,
                alias dicta doloremque excepturi facere fugiat hic illo iusto molestias nisi nulla officiis quas qui,
                sapiente suscipit?
            </div>
            <div>Corporis deserunt ducimus earum eos et in molestiae reprehenderit similique totam. A asperiores at cum
                delectus deleniti esse et explicabo, iusto laboriosam nihil pariatur perferendis quis saepe totam vero
                voluptate.
            </div>
        </div>
    )
}

