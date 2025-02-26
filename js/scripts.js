/*!
* Start Bootstrap - Creative v7.0.7 (https://startbootstrap.com/theme/creative)
* Copyright 2013-2023 Start Bootstrap
* Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-creative/blob/master/LICENSE)
*/
//
// Scripts
// 

window.addEventListener('DOMContentLoaded', event => {

    // Navbar shrink function
    var navbarShrink = function () {
        const navbarCollapsible = document.body.querySelector('#mainNav');
        if (!navbarCollapsible) {
            return;
        }
        if (window.scrollY === 0) {
            navbarCollapsible.classList.remove('navbar-shrink')
        } else {
            navbarCollapsible.classList.add('navbar-shrink')
        }

    };

    // Shrink the navbar 
    navbarShrink();

    // Shrink the navbar when page is scrolled
    document.addEventListener('scroll', navbarShrink);

    // Activate Bootstrap scrollspy on the main nav element
    const mainNav = document.body.querySelector('#mainNav');
    if (mainNav) {
        new bootstrap.ScrollSpy(document.body, {
            target: '#mainNav',
            rootMargin: '0px 0px -40%',
        });
    };

    // Collapse responsive navbar when toggler is visible
    const navbarToggler = document.body.querySelector('.navbar-toggler');
    const responsiveNavItems = [].slice.call(
        document.querySelectorAll('#navbarResponsive .nav-link')
    );
    responsiveNavItems.map(function (responsiveNavItem) {
        responsiveNavItem.addEventListener('click', () => {
            if (window.getComputedStyle(navbarToggler).display !== 'none') {
                navbarToggler.click();
            }
        });
    });

    fetch('tictactoe.py')
        .then(response => response.text())
        .then(data => {
            document.getElementById('python-code').textContent = data; // Display Python code as text
        })
        .catch(error => {
            console.error('Error fetching the Python file:', error);
            document.getElementById('python-code').textContent = error.message;
        });

    fetch('freq32bit.asm')
        .then(response => response.text())
        .then(data => {
            document.getElementById('assembly-code').textContent = data; // Display assembly code as text
        })
        .catch(error => {
            console.error('Error fetching the Assembly file:', error);
            document.getElementById('assembly-code').textContent = error.message;
        });

    fetch('Program.cs')
        .then(response => response.text())
        .then(data => {
            document.getElementById('cs-code').textContent = data; // Display C# code as text
        })
        .catch(error => {
            console.error('Error fetching the C# file:', error);
            document.getElementById('cs-code').textContent = error.message;
        });

});
