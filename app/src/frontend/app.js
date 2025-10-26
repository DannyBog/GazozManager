document.addEventListener('DOMContentLoaded', () => {
	fetchGazozim();

	document.getElementById('add-form').addEventListener('submit', async (e) => {
		e.preventDefault();
		const body = {
			name: document.getElementById('name').value,
			supermarket: document.getElementById('supermarket').value,
			price_ils: parseFloat(document.getElementById('price_ils').value)
		};

		const res = await fetch('/gazoz', {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify(body)
		});

		if (res.ok) {
			fetchGazozim();
		} else {
			alert("Error adding gazoz.");
		}
	});
});

async function fetchGazozim() {
	const res = await fetch(`/gazoz`);
	const gazozim = await res.json();

	const list = document.getElementById('gazoz-list');
	list.innerHTML = '';

	for (const gazoz of gazozim) {
		const item = document.createElement('li');
		item.innerHTML = `
			<strong>${gazoz.name}</strong> (${gazoz.supermarket}) – ${gazoz.price_ils}₪
			<button onclick="deleteGazoz('${gazoz.id}')">🗑️ Delete</button>
		`;
		list.appendChild(item);
	}
}

async function deleteGazoz(id) {
	const res = await fetch(`/gazoz/${id}`, { method: 'DELETE' });
	if (res.ok) {
		fetchGazozim();
	} else {
		alert("Error deleting gazoz.");
	}
}
