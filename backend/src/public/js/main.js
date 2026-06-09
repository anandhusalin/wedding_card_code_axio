document.addEventListener('DOMContentLoaded', () => {
    // GSAP Animations
    gsap.registerPlugin(ScrollTrigger);

    // Reveal elements on scroll
    const revealElements = document.querySelectorAll('.gs-reveal');
    revealElements.forEach((el) => {
        gsap.fromTo(el, 
            { 
                y: 50, 
                opacity: 0 
            }, 
            {
                y: 0,
                opacity: 1,
                duration: 1,
                ease: 'power3.out',
                scrollTrigger: {
                    trigger: el,
                    start: 'top 85%',
                    toggleActions: 'play none none reverse'
                }
            }
        );
    });

    // Parallax effect for hero
    gsap.to('.hero-section', {
        backgroundPosition: '50% 100%',
        ease: 'none',
        scrollTrigger: {
            trigger: '.hero-section',
            start: 'top top',
            end: 'bottom top',
            scrub: true
        }
    });

    // RSVP Form Submission
    const rsvpForm = document.getElementById('rsvpForm');
    if (rsvpForm) {
        rsvpForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const formData = new FormData(rsvpForm);
            const data = Object.fromEntries(formData.entries());
            const weddingId = data.weddingId;
            delete data.weddingId;

            const btn = rsvpForm.querySelector('button[type="submit"]');
            const originalText = btn.innerText;
            btn.innerText = 'Sending...';
            btn.disabled = true;

            try {
                const response = await fetch(`/api/v1/rsvp/${weddingId}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(data),
                });

                const result = await response.json();

                if (result.success) {
                    rsvpForm.style.display = 'none';
                    document.getElementById('rsvpSuccess').style.display = 'block';
                } else {
                    alert(result.error?.message || 'Failed to submit RSVP');
                }
            } catch (err) {
                alert('An error occurred. Please try again.');
            } finally {
                btn.innerText = originalText;
                btn.disabled = false;
            }
        });
    }
});

function openRsvpModal() {
    document.getElementById('rsvpModal').style.display = 'flex';
    document.body.style.overflow = 'hidden'; // Prevent background scrolling
}

function closeRsvpModal() {
    document.getElementById('rsvpModal').style.display = 'none';
    document.body.style.overflow = '';
}
